defmodule InjectDetect.State.UserReducer do

  defmacro __using__(_opts) do
    quote do

      def apply_event({:got_started, user}, state) do
        put_in(state, [:users, user.user_id], %{
          id: user.user_id,
          auth_token: user.auth_token,
          email: user.email,
        })
      end

      def apply_event({:requested_sign_in_link, data}, state) do
        put_in(state, [:users, data.user_id, :requested_token], data.requested_token)
      end

      def apply_event({:verified_requested_token, data}, state) do
        put_in(state, [:users, data.user_id, :auth_token], data.auth_token)
      end

      def apply_event({:signed_out, data}, state) do
        put_in(state, [:users, data.user_id, :auth_token], nil)
      end

    end
  end

end
