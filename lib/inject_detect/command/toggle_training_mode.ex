defmodule InjectDetect.Command.ToggleTrainingMode do
  defstruct application_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.ToggleTrainingMode do

  alias InjectDetect.Event.TurnedOffTrainingMode
  alias InjectDetect.Event.TurnedOnTrainingMode
  alias InjectDetect.State.Application

  def toggle_training_mode(application = %{user_id: user_id}, command, %{user_id: user_id}) do
    case application.training_mode do
      true ->
        {:ok, [%TurnedOffTrainingMode{application_id: command.application_id,
                                      user_id: user_id}], %{application_id: application.id}}
      false ->
        {:ok, [%TurnedOnTrainingMode{application_id: command.application_id,
                                     user_id: user_id}], %{application_id: application.id}}
    end
  end

  def toggle_training_mode(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context, state) do
    Application.find(state, command.application_id)
    |> toggle_training_mode(command, context)
  end

end
