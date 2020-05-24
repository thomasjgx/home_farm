defmodule HomeFarmWeb.PageController do
  use HomeFarmWeb, :controller

  alias HomeFarm.Sensors

  def index(conn, _params) do
    sensors = Sensors.get_all
    render(conn, "index.html", sensors: sensors)
  end
end
