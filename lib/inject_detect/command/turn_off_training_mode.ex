defmodule InjectDetect.Command.TurnOffTrainingMode do
  defstruct application_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.TurnOffTrainingMode do

  alias InjectDetect.Event.TurnedOffTrainingMode
  alias InjectDetect.State.Application

  def turn_off_training_mode(%{training_mode: false, user_id: user_id}, _, %{user_id: user_id}) do
    {:error, %{code: :training_mode_off,
               error: "Training mode is already off",
               message: "Training mode is already off"}}
  end

  def turn_off_training_mode(application = %{user_id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%TurnedOffTrainingMode{application_id: command.application_id}], %{application_id: application.id}}
  end

  def turn_off_training_mode(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  # TODO: authorization

  def handle(command, context) do
    Application.find(command.application_id)
    |> turn_off_training_mode(command, context)
  end

end
