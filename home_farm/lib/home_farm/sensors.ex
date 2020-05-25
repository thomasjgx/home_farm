defmodule HomeFarm.Sensors do
  @moduledoc """
  Sensors context module
  """

  import Ecto.Query

  alias HomeFarm.Repo
  alias HomeFarm.Sensors.{Sensor, SensorValue}

  def get_all() do
    Repo.all(Sensor)
  end

  def get_sensor!(id) do
    Repo.get!(Sensor, id)
  end

  def get_readings_by_sensor(sensor) do
    (from s in SensorValue, where: s.sensor_id == ^sensor.id, order_by: [desc: :time], limit: 1000)
    |> Repo.all()
  end

end
