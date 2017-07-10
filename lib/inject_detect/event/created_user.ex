defmodule InjectDetect.Event.CreatedUser do
  defstruct agreed_to_tos: nil,
            email: nil,
            referral_code: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.CreatedUser do

  alias InjectDetect.State.Base

  def apply(event, state) do
    Base.add_user(state, %{agreed_to_tos: event.agreed_to_tos,
                           email: event.email,
                           referral_code: event.referral_code,
                           id: event.user_id})
  end

end
