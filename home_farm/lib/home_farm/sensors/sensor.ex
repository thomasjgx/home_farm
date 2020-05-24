defmodule HomeFarm.Sensors.Sensor do
  use Ecto.Schema
  import Ecto.Changeset

  alias HomeFarm.Repo

  @type t :: %__MODULE__{name: String.t(), key: String.t(), type: String.t(), description: String.t()}

  schema "sensors" do
    field :name, :string
    field :key, :string
    field :type, :string
    field :description, :string
    belongs_to :reading_source, HomeFarm.ReadingSources.ReadingSource

    timestamps()
  end

  def changeset(sensor, attrs) do
    sensor
    |> cast(attrs, [:name, :key, :type, :description, :reading_source_id])
    |> validate_required([:name, :key, :type, :reading_source_id])
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
end
