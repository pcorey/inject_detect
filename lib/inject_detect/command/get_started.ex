defmodule InjectDetect.Command.GetStarted do
  defstruct email: nil,
            application_name: nil,
            application_size: nil,
            referral_code: nil,
            agreed_to_tos: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.GetStarted do

  alias InjectDetect.Event.AddedApplication
  alias InjectDetect.Event.AddedCredits
  alias InjectDetect.Event.CreatedCustomer
  alias InjectDetect.Event.GivenAuthToken
  alias InjectDetect.Event.GotStarted
  alias InjectDetect.Event.SetRefillAmount
  alias InjectDetect.Event.SetRefillTrigger
  alias InjectDetect.State.User

  def create_customer(command, user_id, application_id, application_token, auth_token) do
    with {:ok, customer} <- Stripe.create_customer(user_id) do
      {:ok, [%GotStarted{agreed_to_tos: command.agreed_to_tos,
                         email: command.email,
                         referral_code: command.referral_code,
                         user_id: user_id},
             %AddedApplication{id: application_id,
                               name: command.application_name,
                               size: command.application_size,
                               token: application_token,
                               user_id: user_id},
             %GivenAuthToken{auth_token: auth_token, user_id: user_id},
             %CreatedCustomer{user_id: user_id, customer_id: customer["id"]},
             %AddedCredits{user_id: user_id, credits: 10_000},
             %SetRefillAmount{user_id: user_id, refill_amount: 10_000},
             %SetRefillTrigger{user_id: user_id, refill_trigger: 1_000}
            ], %{user_id: user_id}}
    else
      _ -> {:error, %{code: :cannot_create_customer,
                      error: "Can't create customer.",
                      message: "Can't create customer."}}
    end
  end

  def handle(command, _context) do
    unless user = User.find(email: command.email) do
      user_id = InjectDetect.generate_id()
      application_id = InjectDetect.generate_id()
      application_token = InjectDetect.generate_token(application_id)
      auth_token = InjectDetect.generate_token(user_id)
      create_customer(command, user_id, application_id, application_token, auth_token)
    else
      {:error, %{code: :email_taken,
                 error: "That email is already being used.",
                 message: "Email taken"}}
    end
  end

end
