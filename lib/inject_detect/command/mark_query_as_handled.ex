defmodule InjectDetect.Command.MarkQueryAsHandled do
  defstruct application_id: nil,
            query_id: nil
end

defimpl InjectDetect.Command,
   for: InjectDetect.Command.MarkQueryAsHandled do

  alias InjectDetect.Event.MarkedQueryAsHandled
  alias InjectDetect.State.Application
  alias InjectDetect.State.UnexpectedQuery

  def handle_for_query(nil, _application_id) do
    {:error, %{code: :query_not_found,
               error: "Query not found",
               message: "Query not found"}}
  end

  def handle_for_query(query, application_id) do
    context = %{application_id: application_id, query_id: query.id}
    {:ok, [%MarkedQueryAsHandled{application_id: application_id,
                                 query_id: query.id,
                                 user_id: query.user_id}], context}
  end

  def handle_for_application(nil, _command) do
    {:error, %{code: :application_not_found,
               error: "Application not found",
               message: "Application not found"}}
  end

  def handle_for_application(%{user_id: user_id}, command, %{user_id: user_id}) do
    UnexpectedQuery.find(command.application_id, command.query_id)
    |> handle_for_query(command.application_id)
  end

  def handle_for_application(nil, _command) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context) do
    Application.find(command.application_id)
    |> handle_for_application(command, context)
  end

end
