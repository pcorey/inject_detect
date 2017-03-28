defmodule InjectDetect.User.Handler do
  use GenServer

  alias Ecto.UUID
  alias InjectDetect.Handler
  alias InjectDetect.State
  alias Phoenix.Token

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    Registry.register(Handler.Registry, :get_started, __MODULE__)
    Registry.register(Handler.Registry, :request_sign_in_link, __MODULE__)
    Registry.register(Handler.Registry, :sign_out, __MODULE__)
    Registry.register(Handler.Registry, :verify_requested_token, __MODULE__)
  end

  def handle_call({:get_started, args = %{email: email}}, _, _) do
    unless State.find_user(:email, email) do
      user_id = UUID.generate()
      auth_token = Token.sign(InjectDetect.Endpoint, "token", user_id)
      data = args
      |> Map.put(:user_id, user_id)
      |> Map.put(:auth_token, auth_token)
      {:reply, {:ok, [{:got_started, user_id, data}]}, []}
    else
      {:reply, {:error, :email_taken}, []}
    end
  end

  def handle_call({:sign_out, %{user_id: user_id}}, _, _) do
    {:reply, {:ok, [{:signed_out, user_id, %{user_id: user_id}}]}, []}
  end

  def handle_call({:request_sign_in_link, %{email: email}}, _, _) do
    requested_token = Token.sign(InjectDetect.Endpoint, "token", email)
    if user = State.find_user(:email, email) do
      data = %{
        email: email,
        requested_token: requested_token,
        user_id: user.id
      }
      {:reply, {:ok, [{:requested_sign_in_link, user.id, data}]}, []}
    else
      {:reply, {:error, :user_not_found}, []}
    end
  end

  def handle_call({:verify_requested_token, %{token: token}}, _, _) do
    if user = State.find_user(:requested_token, token) do
      data = %{
        token: token,
        user_id: user.id,
        auth_token: Token.sign(InjectDetect.Endpoint, "token", user.id)
      }
      {:reply, {:ok, [{:verified_requested_token, user.id, data}]}, []}
    else
      {:reply, {:error, :user_not_found}, []}
    end
  end

end
