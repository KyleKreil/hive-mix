defmodule Increaser.Server do
  @moduledoc """
  Documentation for `Increaser.Server`.
  Hand-written service that does the job a GenServer would do
  """
    alias Increaser.Counter

    # Public API
  def start(input) do
    initial = Counter.new(input)
    spawn(fn -> loop(initial) end)
  end

  def inc(server_pid) do
    send(server_pid, :inc)
  end

  def show(server_pid) do
    send(server_pid, {:show, self()})

    receive do
      msg -> msg
    end
  end

  def loop(count) do
    count
    |> listen()
    |> loop()
  end

  def listen(count) do
    receive do
      :inc ->
        Counter.add(count, 1)

      {:show, from_pid} ->
        send(from_pid, Counter.show(count))
        count
    end
  end
end
