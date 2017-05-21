defmodule InjectDetect.Command.SendSignInEmail do
  defstruct user_id: nil,
            email: nil,
            requested_token: nil
end

defimpl InjectDetect.Command,
   for: InjectDetect.Command.SendSignInEmail do

  alias InjectDetect.Event.SentSignInEmail

  def handle(command, _context) do
    Email.verify_html_email(command.email, command.requested_token)
    |> InjectDetect.Mailer.deliver_later
    {:ok, [%SentSignInEmail{user_id: command.user_id,
                            email: command.email,
                            requested_token: command.requested_token}]}
  end

end
