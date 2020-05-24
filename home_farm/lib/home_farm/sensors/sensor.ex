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
    field :ip_address, :string

    timestamps()
  end

  def changeset(sensor, attrs) do
    sensor
    |> cast(attrs, [:name, :key, :type, :description, :ip_address])
    |> validate_required([:name, :key, :type, :ip_address])
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
