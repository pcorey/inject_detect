defmodule InjectDetect.State.UserReducer do

  defmacro __using__(_opts) do
    quote do

      def apply_event({:got_started, user}, state) do
        put_in(state, [:users, user.id], %{
          id: user.id,
          token: user.token,
          email: user.email,
        })
        # update_in(state, [:users], fn
        #   nil   -> [%{id: data["id"], email: data["email"]}]
        #   users -> users ++ [%{id: data["id"], email: data["email"]}]
        # end)
      end

      def apply_event({:requested_new_token, data}, state) do
        put_in(state, [:users, data.id, :requested_token], data.requested_token)
      end

    end
  end

end
