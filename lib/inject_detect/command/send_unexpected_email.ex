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

  def can_send_email(%{sent_unexpected_at: sent_unexpected_at}) do
    with {:ok, date, _} <- DateTime.from_iso8601(sent_unexpected_at),
         shifted <- Timex.shift(date, minutes: 10),
         :lt <- DateTime.compare(shifted, DateTime.utc_now)
    do
      true
    else
      _ -> false
    end
  end
  def can_send_email(_), do: true

  def handle(command, _context) do
    with {:ok, state} <- State.get(),
         user <- User.find(state, command.user_id),
         true <- can_send_email(user),
         application <- Application.find(state, command.application_id),
         unexpected_query <- UnexpectedQuery.find(state, command.application_id, command.query_id)
    do
      Email.unexpected_html_email(user.email, application, unexpected_query)
      |> InjectDetect.Mailer.deliver_later
      {:ok, [%SentUnexpectedEmail{user_id: command.user_id,
                                  application_id: command.application_id,
                                  query_id: command.query_id,
                                  sent_at:  DateTime.utc_now |> DateTime.to_iso8601}]}
    else
      _ -> {:error, %{code: :not_sending, error: "Not sending", message: "Not sending"}}
    end
  end

end
