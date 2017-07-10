defmodule InjectDetect.Command.SendSignInEmail do
  defstruct user_id: nil,
            email: nil,
            requested_token: nil
end

defimpl InjectDetect.Command,
   for: InjectDetect.Command.SendSignInEmail do

  alias InjectDetect.Event.SentSignInEmail
  alias InjectDetect.State.User

  def handle(command, _context, state) do
    User.find(state, command.user_id)
    |> Email.verify_html_email(command.requested_token)
    |> InjectDetect.Mailer.deliver_later
    {:ok, [%SentSignInEmail{user_id: command.user_id,
                            email: command.email,
                            requested_token: command.requested_token}]}
  end

end
