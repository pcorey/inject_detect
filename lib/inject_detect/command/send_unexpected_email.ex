defmodule InjectDetect.Command.SendUnexpectedEmail do
  defstruct user_id: nil,
            application_id: nil,
            query_id: nil
end

defimpl InjectDetect.Command,
   for: InjectDetect.Command.SendUnexpectedEmail do

  alias InjectDetect.Event.SentUnexpectedEmail
  alias InjectDetect.State
  alias InjectDetect.State.Application
  alias InjectDetect.State.UnexpectedQuery
  alias InjectDetect.State.User

  def handle(command, _context) do
    with {:ok, state} <- State.get(),
         user <- User.find(state, command.user_id),
         application <- Application.find(state, command.application_id),
         unexpected_query <- UnexpectedQuery.find(state, command.application_id, command.query_id)
    do
      Email.unexpected_html_email(user.email, application, unexpected_query)
      |> InjectDetect.Mailer.deliver_later
      {:ok, [%SentUnexpectedEmail{user_id: command.user_id,
                                  application_id: command.application_id,
                                  query_id: command.query_id}]}
    end
  end

end
