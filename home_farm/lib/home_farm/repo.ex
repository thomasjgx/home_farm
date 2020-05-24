defmodule HomeFarm.Repo do
  use Ecto.Repo,
    otp_app: :home_farm,
    adapter: Ecto.Adapters.Postgres
end
