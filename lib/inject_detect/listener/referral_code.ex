defmodule InjectDetect.Listener.ReferralCode do

  alias InjectDetect.Event.CreatedUser

  def handle_referral_code(user_id, "I <3 Inject Detect", context) do
    # %AddCredits{user_id: user_id, credits: 100_000}
    # |> InjectDetect.CommandHandler.handle(context)
  end
  def handle_referral_code(_user_id, _referral_code, _context), do: :ok

  def handle(event = %CreatedUser{}, context) do
    handle_referral_code(event.user_id, event.referral_code, context)
  end
  def handle(_event, _context), do: :ok

end
