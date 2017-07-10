defmodule InjectDetect.Command.CreateUser do
  defstruct email: nil,
            application_name: nil,
            application_size: nil,
            referral_code: nil,
            agreed_to_tos: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.CreateUser do

  alias InjectDetect.Event.AddedApplication
  alias InjectDetect.Event.CreatedCustomer
  alias InjectDetect.Event.GivenAuthToken
  alias InjectDetect.Event.GivenUnsubscribeToken
  alias InjectDetect.Event.CreatedUser
  alias InjectDetect.State.User

  def create_customer(command, user_id, application_id, application_token, auth_token, unsubscribe_token) do
    with {:ok, customer} <- Stripe.create_customer(user_id) do
      {:ok, [%CreatedUser{agreed_to_tos: command.agreed_to_tos,
                          email: command.email,
                          referral_code: command.referral_code,
                          user_id: user_id},
             %AddedApplication{id: application_id,
                               name: command.application_name,
                               size: command.application_size,
                               token: application_token,
                               user_id: user_id},
             %GivenAuthToken{auth_token: auth_token, user_id: user_id},
             %GivenUnsubscribeToken{unsubscribe_token: unsubscribe_token, user_id: user_id},
             %CreatedCustomer{user_id: user_id, customer_id: customer["id"]}
            ], %{user_id: user_id}}
    else
      _ -> {:error, %{code: :cannot_create_customer,
                      error: "Can't create customer.",
                      message: "Can't create customer."}}
    end
  end

  def handle(command, _context, state) do
    unless user = User.find(state, email: command.email) do
      user_id = InjectDetect.generate_id()
      application_id = InjectDetect.generate_id()
      application_token = InjectDetect.generate_token(application_id)
      auth_token = InjectDetect.generate_token(user_id)
      unsubscribe_token = InjectDetect.generate_token(user_id)
      create_customer(command, user_id, application_id, application_token, auth_token, unsubscribe_token)
    else
      {:error, %{code: :email_taken,
                 error: "That email is already being used.",
                 message: "Email taken"}}
    end
  end

end
