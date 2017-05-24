defmodule InjectDetect.Web.Context do
  @behaviour Plug

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
    with ["Bearer " <> auth_token] <- get_req_header(conn, "authorization"),
         {:ok, user_id}            <- authorize(auth_token)
    do
      {:ok, %{user_id: user_id}}
    else
      []    -> {:ok, %{}}
      error -> error
    end
  end

  defp authorize(auth_token) do
    with user <- InjectDetect.State.User.find(auth_token: auth_token),
         user_id <- user.id,
         {:ok, user_id} <- InjectDetect.verify_token(user.auth_token)
    do
      {:ok, user.id}
    else
      _ -> {:error, "Invalid authorization token"}
    end
  end

end
