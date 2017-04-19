# defmodule InjectDetect.Command.DismissUnexpectedQuery do
#   defstruct application_id: nil,
#             query: nil
# end

# defimpl InjectDetect.Command, for: InjectDetect.Command.DismissUnexpectedQuery do

#   alias InjectDetect.Event.DismissedUnexpectedQuery
#   alias InjectDetect.State
#   alias InjectDetect.State.Application
#   alias InjectDetect.State.Query

#   def handle(command, _context) do
#     Application.find(command.application_id)
#     |> ingest_for_application(command)
#   end

# end
