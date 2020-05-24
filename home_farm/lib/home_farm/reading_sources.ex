defmodule HomeFarm.ReadingSources do
  @moduledoc """
  ReadingSources context module
  """

  import Ecto.Query

  alias HomeFarm.Repo
  alias HomeFarm.{ReadingSources.ReadingSource, Sensors.Sensor}

  def get_all() do
    Repo.all(ReadingSource)
  end

  def get_reading_source!(id) do
    Repo.get!(ReadingSource, id)
  end

  def get_sensors_by_reading_source(reading_source) do
    (from s in Sensor, where: s.reading_source_id == ^reading_source.id)
    |> Repo.all()
  end

end
