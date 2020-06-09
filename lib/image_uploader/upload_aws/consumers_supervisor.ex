defmodule ImageUploader.UploadAws.ConsumersSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok), do: DynamicSupervisor.init(strategy: :one_for_one)

  # Want to spawn any consumer module via the single ConsumersSupervisor
  def start_consumer(consumer_module) do
    spec = {consumer_module, []}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
