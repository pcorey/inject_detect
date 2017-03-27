defmodule InjectDetect.Command.RequestSignInLink do

  defstruct email: nil

  alias __MODULE__
  alias Phoenix.Token
  alias InjectDetect.State

  def handle(arguments = %{email: email}) do
    requested_token = Phoenix.Token.generate(InjectDetect.Endpoint, "token", email)

    if user = State.find_user(:email, email) do
      data = arguments
      |> Map.from_struct
      |> Map.put(:requested_token, requested_token)

      {:ok, [{:requested_sign_in_link, user.id, data}]}
    else
      {:error, :user_not_found}
    end

  end

  def resolve(%{email: email}, _info) do
    command = %RequestSignInLink{email: email}
    with {:ok, [{_, id, _}]} <- InjectDetect.CommandHandler.handle(command) do
      {:ok, %{id: id}}
    else
      {:error, error} -> {:error, error}
      error           -> {:error, error}
    end
  end

end
