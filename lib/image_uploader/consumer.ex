defmodule ImageUploader.Consumer do
  use GenStage

  @max_demand 10
  @min_demand 5
  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :the_state_does_not_matter,
     subscribe_to: [{ImageUploader.Producer, max_demand: @max_demand, min_demand: @min_demand}]}
  end

  def handle_events(events, _from, state) do
    IO.inspect(Enum.count(events), label: "Total of events")

    for event <- events do
      IO.inspect({event, self()}, label: "Push to AWS: ")
      # Simulate time to upload AWS
      Process.sleep(1_000)
    end

    {:noreply, [], state}
  end
end
