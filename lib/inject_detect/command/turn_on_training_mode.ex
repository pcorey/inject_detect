defmodule InjectDetect.Command.TurnOnTrainingMode do
  defstruct application_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.TurnOnTrainingMode do

  alias InjectDetect.Event.TurnedOnTrainingMode
  alias InjectDetect.State.Application

  def turn_on_training_mode(%{training_mode: true, user_id: user_id}, _, %{user_id: user_id}) do
    {:error, %{code: :training_mode_on,
               error: "Training mode is already on",
               message: "Training mode is already on"}}
  end

  def turn_on_training_mode(application = %{user_id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%TurnedOnTrainingMode{application_id: command.application_id,
                                 user_id: user_id}], %{application_id: application.id}}
  end

  def turn_on_training_mode(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  # TODO: authorization

  def handle(command, context) do
    Application.find(command.application_id)
    |> turn_on_training_mode(command, context)
  end

end
