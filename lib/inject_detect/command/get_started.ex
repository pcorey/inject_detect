defmodule InjectDetect.Command.GetStarted do

  defstruct email: nil,
            application_name: nil,
            application_size: nil,
            agreed_to_tos: nil

  alias Ecto.UUID

  def handle(arguments = %{
        email: email,
        application_name: application_name,
        application_size: appliation_size,
        agreed_to_tos: agreed_to_tos
      }) do

    id = UUID.generate()

    data = arguments
    |> Map.from_struct
    |> Map.put(:id, id)

    [{:got_started, id, data}]

  end

end
