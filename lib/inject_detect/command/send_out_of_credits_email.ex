defmodule InjectDetect.Command.SendOutOfCreditsEmail do
  defstruct user_id: nil
end

defimpl InjectDetect.Command,
   for: InjectDetect.Command.SendOutOfCreditsEmail do

  alias InjectDetect.Event.SentOutOfCreditsEmail
  alias InjectDetect.State
  alias InjectDetect.State.User

  def can_send_email(%{subscribed: false}), do: false
  def can_send_email(%{sent_out_of_credits_at: sent_out_of_credits_at}) do
    with {:ok, date, _} <- DateTime.from_iso8601(sent_out_of_credits_at),
         shifted <- Timex.shift(date, hours: 24),
         :lt <- DateTime.compare(shifted, DateTime.utc_now)
    do
      true
    else
      _ -> false
    end
  end
  def can_send_email(_), do: true

  def handle(command, _context, state) do
    with user <- User.find(state, command.user_id),
         true <- can_send_email(user)
    do
      Email.out_of_credits_html_email(user)
      |> InjectDetect.Mailer.deliver_later
      {:ok, [%SentOutOfCreditsEmail{user_id: command.user_id,
                                    sent_at:  DateTime.utc_now |> DateTime.to_iso8601}]}
    else
      _ -> {:error, %{code: :not_sending, error: "Not sending", message: "Not sending"}}
    end
  end

end
