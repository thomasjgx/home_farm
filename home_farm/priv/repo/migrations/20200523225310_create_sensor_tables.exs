defmodule HomeFarm.Repo.Migrations.CreateSensorTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS timescaledb", "SELECT 1"

    create table(:reading_sources) do
      add :name, :string, null: false
      add :description, :string
      add :ip_address, :string, null: false

      timestamps()
    end

    create table(:sensors) do
      add :name, :string, null: false
      add :key, :string, null: false
      add :type, :string, null: false
      add :description, :string
      add :reading_source_id, references(:reading_sources), null: false

      timestamps()
    end

    create table(:sensor_values, primary_key: false) do
      add :sensor_id, references(:sensors), null: false
      add :time, :timestamp, null: false
      add :reading, :decimal
    end

    execute("SELECT create_hypertable('sensor_values', 'time')", "SELECT 1")
  end
end
