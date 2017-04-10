defmodule InjectDetect.Command.IngestQueries do
  defstruct application_id: nil,
            queries: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.IngestQueries do

  alias InjectDetect.Event.IngestedQueries
  alias InjectDetect.State.Application

  def handle(%{application_id: application_id,
               queries: queries}, _context) do
    if Application.find(application_id) do
      {:ok, [%IngestedQueries{application_id: application_id, queries: queries}]}
    else
      {:error, %{code: :invalid_token,
                 error: "Invalid application token",
                 message: "Invalid token"}}
    end
  end

end
