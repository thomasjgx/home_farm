defmodule HomeFarmWeb.ReadingSourceController do
  use HomeFarmWeb, :controller

  alias HomeFarm.{ReadingSources, ReadingSources.ReadingSource}

  def index(conn, _params) do
    reading_sources = ReadingSources.get_all
    render(conn, "index.html", reading_sources: reading_sources)
  end

  def new(conn, _) do
    changeset = ReadingSource.changeset(%ReadingSource{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"reading_source" => params}) do
    case ReadingSource.create(%ReadingSource{}, params)  do
      {:ok, _reading_source} ->
        conn
        |> redirect(to: Routes.reading_source_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    reading_source = ReadingSources.get_reading_source!(id)
    changeset = ReadingSource.changeset(reading_source, %{})
    render(conn, "edit.html", reading_source: reading_source, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reading_source" => params}) do
    reading_source = ReadingSources.get_reading_source!(id)
    case ReadingSource.update(reading_source, params) do
      {:ok, _reading_source} ->
        conn
        |> redirect(to: Routes.reading_source_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", reading_source: reading_source, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reading_source = ReadingSources.get_reading_source!(id)
    sensors = ReadingSources.get_sensors_by_reading_source(reading_source)
    render(conn, "show.html", reading_source: reading_source, sensors: sensors)
  end
end
