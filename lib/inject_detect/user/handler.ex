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
  end

  def handle_call({:get_started, args = %{email: email}}, _, _) do
    unless State.find_user(:email, email) do
      id = UUID.generate()
      auth_token = Token.sign(InjectDetect.Endpoint, "token", id)
      data = args
      |> Map.put(:id, id)
      |> Map.put(:auth_token, auth_token)
      {:reply, {:ok, [{:got_started, id, data}]}, []}
    else
      {:reply, {:error, :email_taken}, []}
    end
  end

  def handle_call({:request_sign_in_link, %{email: email}}, _, _) do
    requested_token = Phoenix.Token.generate(InjectDetect.Endpoint, "token", email)
    if user = State.find_user(:email, email) do
      data = %{
        email: email,
        requested_token: requested_token
      }
      {:reply, {:ok, [{:requested_sign_in_link, user.id, data}]}, []}
    else
      {:reply, {:error, :user_not_found}, []}
    end
  end

  def handle_call({:sign_out, %{user_id: user_id}}) do
    {:reply, {:ok, [{:signed_out, user_id, %{user_id: user_id}}]}, []}
  end

end
