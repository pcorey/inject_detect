defmodule InjectDetect.Command.RequestSignInToken do
  defstruct email: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.RequestSignInToken do

  alias InjectDetect.State
  alias InjectDetect.Event.RequestedSignInToken
  alias Phoenix.Token

  def handle(%{email: email}, _context) do
    requested_token = Token.sign(InjectDetect.Endpoint, "token", email)
    if user = State.user(:email, email) do
      {:ok,
       [%RequestedSignInToken{user_id: user.id,
                              email: email,
                              requested_token: requested_token}],
       %{user_id: user.id}}
    else
      {:error, :user_not_found}
    end
  end

end
