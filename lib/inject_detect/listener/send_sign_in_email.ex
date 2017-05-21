defmodule InjectDetect.Listener.SendSignInEmail do
  require Logger

  alias InjectDetect.Command.SendSignInEmail
  alias InjectDetect.Event.RequestedSignInToken
  alias InjectDetect.State.User

  def email_user(nil, requested_token, user_id) do
    Logger.error("Can't find user \"#{user_id}\" to email token.")
  end

  def email_user(user, requested_token, user_id) do
    %SendSignInEmail{user_id: user.id, requested_token: requested_token, email: user.email}
    |> InjectDetect.CommandHandler.handle
  end

  def handle(event = %RequestedSignInToken{}, _context) do
    User.find(event.user_id)
    |> email_user(event.requested_token, event.user_id)
  end
  def handle(_event, _context), do: :ok

end
