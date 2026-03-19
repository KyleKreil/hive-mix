defmodule Increaser.Worker do
use GenServer
  alias Increaser.Counter

  @impl GenServer
  def init(name) do
    IO.puts("Starting worker with name: #{name}")
    {:ok, Counter.new("0")}
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def child_spec(name) do
    %{
      id: name,
      start: {__MODULE__, :start_link, [name]}
    }
  end

  def show(counter \\ __MODULE__) do
    GenServer.call(counter, :show)
  end

  def inc(counter \\ __MODULE__) do
    GenServer.cast(counter, :inc)
  end

  @impl GenServer
  def handle_call(:show, _from, state) do
    result = Counter.show(state)
    {:reply, result, state}
  end

  @impl GenServer
  def handle_cast(:inc, state) do
    result = Counter.add(state, 1)
    {:noreply, result}
  end
end
