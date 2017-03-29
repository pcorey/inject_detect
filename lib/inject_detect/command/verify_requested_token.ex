defmodule InjectDetect.Command.VerifyRequestedToken do
  defstruct token: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.VerifyRequestedToken do

  alias InjectDetect.State
  alias InjectDetect.Event.VerifiedRequestedToken

  def handle(%{token: token}) do
    if user = State.user(:requested_token, token) do
      {:ok, [%VerifiedRequestedToken{token: token,
                                     user_id: user.user_id}]}
    else
      {:error, :user_not_found}
    end
  end

end
