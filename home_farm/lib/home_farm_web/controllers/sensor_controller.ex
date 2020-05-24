defmodule HomeFarmWeb.SensorController do
  use HomeFarmWeb, :controller

  alias HomeFarm.{Sensors, Sensors.Sensor}

  def index(conn, _params) do
    sensors = Sensors.get_all
    render(conn, "index.html", sensors: sensors)
  end

  def new(conn, _) do
    changeset = Sensor.changeset(%Sensor{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"sensor" => params}) do
    case Sensor.create(%Sensor{}, params)  do
      {:ok, _sensor} ->
        conn
        |> redirect(to: Routes.sensor_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    sensor = Sensors.get_sensor!(id)
    changeset = Sensor.changeset(sensor, %{})
    render(conn, "edit.html", sensor: sensor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sensor" => params}) do
    sensor = Sensors.get_sensor!(id)
    case Sensor.update(sensor, params) do
      {:ok, _sensor} ->
        conn
        |> redirect(to: Routes.sensor_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", sensor: sensor, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sensor = Sensors.get_sensor!(id)
    render(conn, "show.html", sensor: sensor)
  end
end
