defmodule InjectDetect.Command.SendVerifyEmail do
  defstruct user_id: nil,
            email: nil,
            requested_token: nil
end

defimpl InjectDetect.Command,
   for: InjectDetect.Command.SendVerifyEmail do

  alias InjectDetect.Event.SentVerifyEmail

  def handle(command, _context) do
    Email.verify_html_email(command.email, command.requested_token)
    |> InjectDetect.Mailer.deliver_now
    {:ok, [%SentVerifyEmail{user_id: command.user_id,
                            email: command.email,
                            requested_token: command.requested_token}]}
  end

end
