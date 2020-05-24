defmodule HomeFarm.Sensors.SensorValue do
  use Ecto.Schema
  import Ecto.Changeset

  alias HomeFarm.Repo

  @primary_key {:time, :naive_datetime, []}

  defimpl Phoenix.Param do
    def to_param(%{time: time}) do
      NaiveDateTime.to_iso8601(time)
    end
  end

  schema "sensor_values" do
    belongs_to :sensor, HomeFarm.Sensors.Sensor
    field :reading, :decimal
  end

  def changeset(sensor_value, attrs) do
    sensor_value
    |> cast(attrs, [:time, :reading, :sensor_id])
    |> validate_required([:time, :reading, :sensor_id])
  end

  def create(struct \\ %__MODULE__{}, params) do
    struct
    |> changeset(params)
    |> Repo.insert()
  end

  def update(struct \\ %__MODULE__{}, params) do
    struct
    |> changeset(params)
    |> Repo.update()
  end

  defmodule Query do
    import Ecto.Query

    def latest(query \\ SensorValue, count) do
      from query, order_by: [desc: :time], limit: ^count
    end
  end

end
