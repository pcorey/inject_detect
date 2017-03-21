defmodule InjectDetect.PageController do
  use InjectDetect.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
