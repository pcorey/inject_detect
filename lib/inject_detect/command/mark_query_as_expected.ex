defmodule InjectDetect.Command.MarkQueryAsExpected do
  defstruct application_id: nil,
            query_id: nil
end

defimpl InjectDetect.Command,
   for: InjectDetect.Command.MarkQueryAsExpected do

  alias InjectDetect.Event.MarkedQueryAsExpected
  alias InjectDetect.State.Application
  alias InjectDetect.State.UnexpectedQuery

  def handle_for_query(nil, _application_id) do
    {:error, %{code: :query_not_found,
               error: "Query not found",
               message: "Query not found"}}
  end

  def handle_for_query(query, application_id) do
    context = %{application_id: application_id, query_id: query.id}
    {:ok, [%MarkedQueryAsExpected{application_id: application_id,
                                  query_id: query.id,
                                  user_id: query.user_id}], context}
  end

  def handle_for_application(nil, _command, _state) do
    {:error, %{code: :application_not_found,
               error: "Application not found",
               message: "Application not found"}}
  end

  def handle_for_application(%{user_id: user_id}, command, %{user_id: user_id}, state) do
    UnexpectedQuery.find(state, command.application_id, command.query_id)
    |> handle_for_query(command.application_id)
  end

  def handle_for_application(nil, _command, _state) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context, state) do
    Application.find(state, command.application_id)
    |> handle_for_application(command, context, state)
  end

end
