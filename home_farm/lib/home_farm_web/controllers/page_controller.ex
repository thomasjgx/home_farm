defmodule HomeFarmWeb.PageController do
  use HomeFarmWeb, :controller

  alias HomeFarm.Sensors

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def api_get_sensors(conn, _params) do
    sensors = 
      Sensors.get_all
      |> Enum.map(fn sensor ->
        %{
          id: sensor.id,
          name: sensor.name,
          type: sensor.type,
          key: sensor.key,
          readings: Sensors.get_readings_by_sensor(sensor)
            |> Enum.map(fn sensor_value ->
              %{
                x: NaiveDateTime.to_string(sensor_value.time),
                y: sensor_value.reading
              }
            end) 
        }
      end)

    conn
    |> json(%{"sensors" => sensors})
  end
end
