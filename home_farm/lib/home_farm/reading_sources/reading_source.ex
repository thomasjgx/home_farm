defmodule HomeFarm.ReadingSources.ReadingSource do
  use Ecto.Schema
  import Ecto.Changeset

  alias HomeFarm.Repo

  @type t :: %__MODULE__{name: String.t(), description: String.t(), ip_address: String.t()}

  schema "reading_sources" do
    field :name, :string
    field :description, :string
    field :ip_address, :string

    timestamps()
  end

  def changeset(reading_source, attrs) do
    reading_source 
    |> cast(attrs, [:name, :description, :ip_address])
    |> validate_required([:name, :ip_address])
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
