defmodule InjectDetect do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(InjectDetect.Repo, []),
      supervisor(InjectDetect.Endpoint, []),
      supervisor(Registry, [:duplicate, InjectDetect.Listener.Registry]),

      worker(InjectDetect.CommandHandler, []),
      worker(InjectDetect.State, []),

      # Supervise event listeners:
      worker(InjectDetect.Listener.EmailToken, []),
      # worker(InjectDetect.Listener.TrainingModeInterceptor, []),
      # worker(InjectDetect.Listener.UnexpectedQueryDetector, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InjectDetect.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InjectDetect.Endpoint.config_change(changed, removed)
    :ok
  end

  def generate_id, do: Ecto.UUID.generate()

  def generate_token(value) do
    Phoenix.Token.sign(InjectDetect.Endpoint, :crypto.strong_rand_bytes(32), value)
  end
end
