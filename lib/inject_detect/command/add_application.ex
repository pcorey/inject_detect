defmodule InjectDetect.Command.AddApplication do
  defstruct user_id: nil,
            application_name: nil,
            application_size: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.AddApplication do

  alias InjectDetect.Event.AddedApplication

  def handle(data = %{user_id: user_id}, %{user_id: user_id}, _state) do
    application_id = InjectDetect.generate_id()
    application_token = InjectDetect.generate_token(application_id)
    {:ok, [%AddedApplication{id: application_id,
                             name: data.application_name,
                             size: data.application_size,
                             token: application_token,
                             user_id: user_id}], %{application_id: application_id}}
  end

  def handle(_data, _context) do
    {:error, %{code: :not_authorized,
               error: "Not authorized.",
               message: "Not authorized."}}
  end

end
