defmodule HomeFarmWeb.SensorController do
  use HomeFarmWeb, :controller

  alias HomeFarm.{Sensors, Sensors.Sensor, ReadingSources}

  def index(conn, _params) do
    sensors = Sensors.get_all
    render(conn, "index.html", sensors: sensors)
  end

  def new(conn, _) do
    changeset = Sensor.changeset(%Sensor{}, %{})
    reading_sources = get_reading_sources_map()
    render(conn, "new.html", changeset: changeset, reading_sources: reading_sources)
  end

  def create(conn, %{"sensor" => params}) do
    case Sensor.create(%Sensor{}, params)  do
      {:ok, _sensor} ->
        conn
        |> redirect(to: Routes.sensor_path(conn, :index))
      {:error, changeset} ->
        reading_sources = get_reading_sources_map()
        render(conn, "new.html", changeset: changeset, reading_sources: reading_sources)
    end
  end

  def edit(conn, %{"id" => id}) do
    sensor = Sensors.get_sensor!(id)
    changeset = Sensor.changeset(sensor, %{})
    reading_sources = get_reading_sources_map()
    render(conn, "edit.html", sensor: sensor, changeset: changeset, reading_sources: reading_sources)
  end

  def update(conn, %{"id" => id, "sensor" => params}) do
    sensor = Sensors.get_sensor!(id)
    case Sensor.update(sensor, params) do
      {:ok, _sensor} ->
        conn
        |> redirect(to: Routes.sensor_path(conn, :index))
      {:error, changeset} ->
        reading_sources = get_reading_sources_map()
        render(conn, "edit.html", sensor: sensor, changeset: changeset, reading_sources: reading_sources)
    end
  end

  def show(conn, %{"id" => id}) do
    sensor = Sensors.get_sensor!(id)
    sensor_values = Sensors.get_readings_by_sensor(sensor)
    render(conn, "show.html", sensor: sensor, sensor_values: sensor_values)
  end

  defp get_reading_sources_map() do
    ReadingSources.get_all
    |> Enum.map(fn reading_source ->
      [key: reading_source.name, value: reading_source.id]
    end)
  end
end
