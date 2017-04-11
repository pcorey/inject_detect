defmodule InjectDetect.Command.TurnOffTrainingMode do
  defstruct application_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.TurnOffTrainingMode do

  alias InjectDetect.Event.TurnedOffTrainingMode
  alias InjectDetect.State.Application

  def turn_off_training_mode(%{training_mode: false}, _) do
    {:error, %{code: :training_mode_off,
               error: "Training mode is already off",
               message: "Training mode is already off"}}
  end

  def turn_off_training_mode(application, command) do
    {:ok, [%TurnedOffTrainingMode{application_id: command.application_id}]}
  end

  def handle(command, _context) do
    Application.find(command.application_id)
    |> turn_off_training_mode(command)
  end

end
