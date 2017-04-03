defmodule InjectDetect.Command.IngestQueries do
  defstruct application_token: nil,
            queries: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.IngestQueries do

  alias InjectDetect.Event.QueriesIngested
  alias InjectDetect.Event.UnexpectedQueryIngested
  alias InjectDetect.State

  # def valid?(query) do
  # end

  # def expected?(application, query) do
  # end

  def handle(data, _context) do
    if application = State.application(:application_token, data.application_token) do
    #   {queries, unexpected_queries} = data.queries
    #   |> Enum.reduce({[], []}, fn
    #     (query, {queries, unexpected_queries}) ->

    #       cond do
    #         invalid?(query) ->
    #     end
    #       with {:ok} <- valid?(query)
    #     {:ok} <- expected?(application, query)
    #       do
    #         {queries ++ [query], unexpected_queries}
    #       else
    #         {{queries, unexpected_queries ++ [query]}}
    #       end
    #       # TODO: Whole application goes here...
    #       {queries ++ [], unexpected_queries ++ []}
    #   end)
    #   events = [%QueriesProcessed{application_id: application.id,
    #                               queries: queries}]
    #   {:ok, events}
    else
      {:error, %{code: :invalid_token,
                 error: "Invalid application token",
                 message: "Invalid token"}}
    end
  end

end
