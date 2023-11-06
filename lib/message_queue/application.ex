defmodule MessageQueue.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MessageQueueWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:message_queue, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MessageQueue.PubSub},
      # Start a worker by calling: MessageQueue.Worker.start_link(arg)
      # {MessageQueue.Worker, arg},
      # Start to serve requests, typically the last entry
      MessageQueueWeb.Endpoint,
      MessageQueue.RateLimiter
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MessageQueue.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MessageQueueWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
