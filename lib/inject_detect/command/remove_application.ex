defmodule InjectDetect.Command.RemoveApplication do
  defstruct application_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.RemoveApplication do

  alias InjectDetect.Event.RemovedApplication
  alias InjectDetect.State.Application

  def remove_application(%{user_id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%RemovedApplication{id: command.application_id, user_id: user_id}]}
  end

  def remove_application(_application, _command, _context) do
    {:error, %{code: :not_authorized,
               error: "Not authorized.",
               message: "Not authorized."}}
  end

  def handle(command, context) do
    Application.find(command.application_id)
    |> remove_application(command, context)
  end

end
