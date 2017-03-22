defmodule InjectDetect.State.GotStartedReducer do

  defmacro __using__(_opts) do
    quote do

      def apply_event({:got_started, data}, state) do
        update_in(state, [:users], fn
          nil -> [%{
                     email: data["email"]
                  }]
          users -> users ++ [%{
                                email: data["email"]
                             }]
        end)
      end

    end
  end

end
