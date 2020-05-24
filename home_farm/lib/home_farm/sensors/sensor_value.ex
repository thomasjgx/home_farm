defmodule HomeFarm.Sensors.SensorValue do
  use Ecto.Schema

  @primary_key false
  schema "sensor_values" do
    belongs_to :sensor, HomeFarm.Sensors.Sensor
    field :time, :naive_datetime
    field :reading, :decimal
  end
end
