defmodule InjectDetect.State.UserReducer do

  defmacro __using__(_opts) do
    quote do

      def apply_event({:got_started, user}, state) do
        put_in(state, [:users, user.id], %{
          id: user.id,
          auth_token: user.token,
          email: user.email,
        })
        # update_in(state, [:users], fn
        #   nil   -> [%{id: data["id"], email: data["email"]}]
        #   users -> users ++ [%{id: data["id"], email: data["email"]}]
        # end)
      end

      def apply_event({:requested_sign_in_link, data}, state) do
        put_in(state, [:users, data.id, :requested_token], data.requested_token)
      end

      def apply_event({:signed_out, data}, state) do
        put_in(state, [:users, data.user_id, :auth_token], nil)
      end

    end
  end

end
