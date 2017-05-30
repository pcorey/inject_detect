defmodule InjectDetect.Command.GetStarted do
  defstruct email: nil,
            application_name: nil,
            application_size: nil,
            agreed_to_tos: nil,
            stripe_token: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.GetStarted do

  alias InjectDetect.Event.AddedApplication
  alias InjectDetect.Event.GivenAuthToken
  alias InjectDetect.Event.GotStarted
  alias InjectDetect.Event.SetStripeToken
  alias InjectDetect.State.User

  def handle(data, _context) do
    unless User.find(email: data.email) do
      user_id = InjectDetect.generate_id()
      application_id = InjectDetect.generate_id()
      application_token = InjectDetect.generate_token(application_id)
      auth_token = InjectDetect.generate_token(user_id)
      {:ok,
       [%GotStarted{agreed_to_tos: data.agreed_to_tos,
                    email: data.email,
                    user_id: user_id},
        %AddedApplication{id: application_id,
                          name: data.application_name,
                          size: data.application_size,
                          token: application_token,
                          user_id: user_id},
        %GivenAuthToken{auth_token: auth_token, user_id: user_id},
        %SetStripeToken{user_id: user_id, stripe_token: data.stripe_token}
       ],
       %{user_id: user_id}}
    else
      {:error, %{code: :email_taken,
                 error: "That email is already being used.",
                 message: "Email taken"}}
    end
  end

end
