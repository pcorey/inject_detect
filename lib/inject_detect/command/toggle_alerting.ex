defmodule InjectDetect.Command.ToggleAlerting do
  defstruct application_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.ToggleAlerting do

  alias InjectDetect.Event.TurnedOffAlerting
  alias InjectDetect.Event.TurnedOnAlerting
  alias InjectDetect.State.Application

  def toggle_alerting(application = %{user_id: user_id}, command, %{user_id: user_id}) do
    case application.alerting do
      true ->
        {:ok, [%TurnedOffAlerting{application_id: command.application_id}], %{application_id: application.id}}
      false ->
        {:ok, [%TurnedOnAlerting{application_id: command.application_id}], %{application_id: application.id}}
    end
  end

  def toggle_alerting(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context) do
    Application.find(command.application_id)
    |> toggle_alerting(command, context)
  end

end
