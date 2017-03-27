defmodule InjectDetect do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(InjectDetect.Repo, []),
      # Start the endpoint when the application starts
      supervisor(InjectDetect.Endpoint, []),

      worker(InjectDetect.CommandHandler, []),
      worker(InjectDetect.State, []),
      worker(InjectDetect.Listener.UserListener, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InjectDetect.Supervisor]
    result = Supervisor.start_link(children, opts)

    InjectDetect.CommandHandler.register(&InjectDetect.Listener.UserListener.notify/1)
    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InjectDetect.Endpoint.config_change(changed, removed)
    :ok
  end
end
