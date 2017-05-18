defmodule InjectDetect.Event.SentVerifyEmail do
  defstruct user_id: nil,
            requested_token: nil,
            email: nil

  alias InjectDetect.Event.SentSignInEmail

  def convert_from(event, version), do: SentSignInEmail.convert_from(event, version)

end
