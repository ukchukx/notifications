defmodule Notifications.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias Notifications.Metrics.Setup
  alias Notifications.Web.Endpoint

  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:notifications)
    Setup.setup()

    children = [
      # Start the Telemetry supervisor
      Notifications.Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Notifications.PubSub},
      # Start the Endpoint (http/https)
      Endpoint,
      {Notifications.Boundary.JobManager, []}
      # Start a worker by calling: Notifications.Worker.start_link(arg)
      # {Notifications.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Notifications.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
