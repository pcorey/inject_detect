defmodule InjectDetect.Command.IngestQueries do
  defstruct application_token: nil,
            queries: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.IngestQueries do

  alias InjectDetect.Event.IngestedExpectedQueries
  alias InjectDetect.Event.IngestedUnexpectedQueries
  alias InjectDetect.State.Application

  defp is_expected?(application, query) do
    application.expected_queries
    |> Enum.find(fn expected_query -> Map.equal?(expected_query, query) end)
    |> case do
          nil -> false
          _   -> true
        end
  end

  defp reduce_queries(application) do
    fn
      (query, {unexpected, expected}) ->
        case is_expected?(application, query) do
          true  -> {unexpected, expected ++ [query]}
          false -> {unexpected ++ [query], expected}
        end
    end
  end

  defp to_events(_application, [], _event_type), do: []
  defp to_events(application, queries, event_type) do
    [struct(event_type, %{application_id: application.id,
                          queries: queries})]
  end

  def handle(%{application_token: application_token,
               queries: queries}, _context) do
    application = Application.find(application_token)
    if application do
      events = queries
      |> Enum.reduce({[], []}, reduce_queries(application))
      |> (fn
            {unexpected, expected} ->
              to_events(application, expected, IngestedExpectedQueries) ++
              to_events(application, unexpected, IngestedUnexpectedQueries)
          end).()
      {:ok, events}
    else
      {:error, %{code: :invalid_token,
                 error: "Invalid application token",
                 message: "Invalid token"}}
    end
  end

end
