defmodule InjectDetect.Command.GetStarted do
  defstruct email: nil,
            application_name: nil,
            application_size: nil,
            agreed_to_tos: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.GetStarted do

  alias Ecto.UUID
  alias Phoenix.Token
  alias InjectDetect.Event.AddedApplication
  alias InjectDetect.Event.GivenAuthToken
  alias InjectDetect.Event.GotStarted
  alias InjectDetect.State

  def handle(data, _context) do
    unless State.user(:email, data.email) do
      user_id = UUID.generate()
      application_id = UUID.generate()
      auth_token = Token.sign(InjectDetect.Endpoint, "token", user_id)
      {:ok,
       [%GotStarted{agreed_to_tos: data.agreed_to_tos,
                    email: data.email,
                    user_id: user_id},
        %AddedApplication{application_id: application_id,
                          application_name: data.application_name,
                          application_size: data.application_size,
                          user_id: user_id},
        %GivenAuthToken{auth_token: auth_token,
                        user_id: user_id}],
       %{user_id: user_id}}
    else
      {:error, %{code: :email_taken,
                 error: "That email is already being used.",
                 message: "Email taken"}}
    end
  end

end
