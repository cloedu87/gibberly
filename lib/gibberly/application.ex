defmodule Gibberly.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GibberlyWeb.Telemetry,
      Gibberly.Repo,
      {DNSCluster, query: Application.get_env(:gibberly, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Gibberly.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Gibberly.Finch},
      # Start a worker by calling: Gibberly.Worker.start_link(arg)
      # {Gibberly.Worker, arg},
      # Start to serve requests, typically the last entry
      GibberlyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gibberly.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GibberlyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
