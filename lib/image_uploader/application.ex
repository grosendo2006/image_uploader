defmodule ImageUploader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ImageUploader.Repo,
      # Start the Telemetry supervisor
      ImageUploaderWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ImageUploader.PubSub},
      # Start the Endpoint (http/https)
      ImageUploaderWeb.Endpoint,
      ImageUploader.ConsumersSupervisor,
      {ImageUploader.Producer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ImageUploader.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ImageUploaderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
