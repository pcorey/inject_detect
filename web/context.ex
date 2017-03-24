defmodule InjectDetect.Web.Context do
  @behaviour Plug

  # use Phoenix.Controller

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})
      {:error, reason} ->
        conn
        |> send_resp(403, reason)
        |> halt()
      _ ->
        conn
        |> send_resp(400, "Bad Request")
        |> halt()
    end
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user}  <- authorize(token)
    do
      {:ok, %{current_user: current_user}}
    else
      []    -> {:ok, %{current_user: nil}}
      error -> error
    end
  end

  defp authorize(token) do
    InjectDetect.State.find_user(:email, token)
    |> case do
         nil  -> {:error, "Invalid authorization token"}
         user -> {:ok, user}
       end
  end

end
