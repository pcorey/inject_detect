defmodule InjectDetect.AuthController do
  use InjectDetect.Web, :controller

  def index(conn, %{"token" => token}) do
    IO.puts("Token received: #{token}")
    render conn, "index.html"
  end
end
