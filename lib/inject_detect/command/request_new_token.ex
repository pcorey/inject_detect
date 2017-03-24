defmodule InjectDetect.Command.RequestNewToken do

  defstruct email: nil

  alias Phoenix.Token
  alias InjectDetect.State

  def handle(arguments = %{email: email}) do
    token = Phoenix.Token.generate(InjectDetect.Endpoint, "token", email)

    if user = State.find_user(:email, email) do
      data = arguments
      |> Map.from_struct
      |> Map.put(:requested_token, token)

      {:ok, [{:requested_new_token, user.id, data}]}
    else
      {:error, :user_not_found}
    end

  end

end
