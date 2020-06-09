defmodule ImageUploader.Producer do
  use GenStage
  alias ImageUploader.ConsumersSupervisor
  alias ImageUploader.Consumer

  @consumer_pool 3
  def start_link(state) do
    GenStage.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    send(self(), :start_consumers)
    {:producer, state}
  end

  @impl true
  def handle_info(:start_consumers, state) do
    Enum.each(1..@consumer_pool, fn _ ->
      ConsumersSupervisor.start_consumer(Consumer)
    end)

    {:noreply, [], state}
  end

  @impl true
  def handle_demand(demand, state) when demand > 0 do
    {images, state} = Enum.split(state, demand)

    {:noreply, images, state}
  end

  def add(event) do
    GenStage.cast(__MODULE__, {:add, event})
  end

  @impl true
  def handle_cast({:add, event}, state) do
    {:noreply, [event], state}
  end
end
