defmodule InjectDetect.IndexController do
  import Plug.Conn

  def init(default), do: default

  def call(conn, opts) do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, "priv/inject-detect/build/index.html")
  end

end
