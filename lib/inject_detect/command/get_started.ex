defmodule InjectDetect.Command.GetStarted do

  defstruct email: nil,
            application_name: nil,
            application_size: nil,
            agreed_to_tos: nil

  alias Ecto.UUID
  alias Phoenix.Token
  alias InjectDetect.State

  def handle(arguments = %{email: email}) do
    unless State.find_user(:email, email) do
      id = UUID.generate()
      token = Token.sign(InjectDetect.Endpoint, "token", id)

      data = arguments
      |> Map.from_struct
      |> Map.put(:id, id)
      |> Map.put(:token, token)

      {:ok, [{:got_started, id, data}]}
    else
      {:error, :email_taken}
    end
  end

end
