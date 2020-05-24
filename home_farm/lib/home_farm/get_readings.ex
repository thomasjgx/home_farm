defmodule HomeFarm.GetReadings do
  @moduledoc """
  A background service to fetch readings from the sensors
  """
  use GenServer

  alias HomeFarm.{ReadingSources, Sensors.SensorValue}

  @interval 10_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.send_after(self(), :work, @interval)
    {:ok, %{last_run_at: nil}}
  end

  def handle_info(:work, _state) do
    get_readings()
    Process.send_after(self(), :work, @interval)

    # By storing last_run_at we get basic monitoring via process inspection
    {:noreply, %{last_run_at: :calendar.local_time()}}
  end

  defp get_readings() do
    IO.inspect "Getting readings..."

    reading_sources = ReadingSources.get_all

    for reading_source <- reading_sources do
      IO.inspect "Checking '#{reading_source.name}' on #{reading_source.ip_address}"
      case HTTPoison.get "http://#{reading_source.ip_address}" do
        {:ok, %{body: body} = response} ->
          readings = Poison.decode!(body)
          for sensor <- ReadingSources.get_sensors_by_reading_source(reading_source) do
            reading = Map.get(readings, sensor.key)
            time = NaiveDateTime.utc_now()
            case SensorValue.create(%SensorValue{}, %{"time" => time, "reading" => reading, "sensor_id" => sensor.id}) do
              {:ok, _} ->
                IO.inspect "#{sensor.name}: #{reading}"
              {:error, changeset} ->
                IO.inspect changeset
            end
          end
          response
        {:error, message} = error  ->
          IO.inspect message
          error
      end
    end
  end
end
