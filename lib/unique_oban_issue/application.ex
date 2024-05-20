defmodule UniqueObanIssue.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UniqueObanIssueWeb.Telemetry,
      UniqueObanIssue.Repo,
      {Oban, Application.fetch_env!(:unique_oban_issue, Oban)},
      {DNSCluster, query: Application.get_env(:unique_oban_issue, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UniqueObanIssue.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: UniqueObanIssue.Finch},
      # Start a worker by calling: UniqueObanIssue.Worker.start_link(arg)
      # {UniqueObanIssue.Worker, arg},
      # Start to serve requests, typically the last entry
      UniqueObanIssueWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UniqueObanIssue.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UniqueObanIssueWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
