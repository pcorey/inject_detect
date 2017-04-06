defmodule InjectDetect.Command.VerifyRequestedToken do
  defstruct token: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.VerifyRequestedToken do

  alias InjectDetect.Event.GivenAuthToken
  alias InjectDetect.Event.VerifiedRequestedToken
  alias InjectDetect.State
  alias InjectDetect.State.User

  def handle(%{token: token}, _context) do
    if user = User.find(requested_token: token) do
      auth_token = InjectDetect.generate_token(user.id)
      {:ok,
       [%VerifiedRequestedToken{token: token, user_id: user.id},
        %GivenAuthToken{auth_token: auth_token, user_id: user.id}],
       %{user_id: user.id}}
    else
      {:error, %{code: :invalid_token,
                 error: "Invalid token",
                 message: "Invalid token"}}
    end
  end

end
