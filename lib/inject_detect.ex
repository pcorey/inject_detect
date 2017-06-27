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

      worker(InjectDetect.State, [])
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
    Phoenix.Token.sign(InjectDetect.Endpoint, "user", value)
  end


  def verify_token(value) do
    Phoenix.Token.verify(InjectDetect.Endpoint, "user", value, max_age: 60*60*24*14)
  end


  def atomify(map) do
    for {k, v} <- map, into: %{}, do: {String.to_atom(k), v}
  end


  def error(message) do
    code = message
    |> String.replace(~r/[^a-zA-Z\s]/, "")
    |> String.replace(~r/\s+/, "_")
    |> String.downcase
    |> String.to_atom
    {:error, %{code: code, error: message, message: message}}
  end


end
