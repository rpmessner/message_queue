defmodule MessageQueue.RateLimiter do
  use GenServer

  def send_message(queue, message) do
    GenServer.call(__MODULE__, {:send_message, queue, message})
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    state = %{}

    {:ok, state}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:send_message, queue, message}, _from, state) do
    messages = state |> Map.get(queue)

    messages =
      case messages do
        nil ->
          next_timer(queue)
          []

        m ->
          m
      end

    new_state = state |> Map.put(queue, messages ++ [message])

    {:reply, nil, new_state}
  end

  @impl true
  def handle_info({:handle_next, queue}, state) do
    messages = state |> Map.get(queue)

    state =
      case messages do
        [message | rest] ->
          # in real world examples this would probably end up being
          # a tuple of values we could feed into apply()
          IO.write("#{queue}: #{message}\n")
          next_timer(queue, poll_rate())
          state |> Map.put(queue, rest)

        _ ->
          state |> Map.delete(queue)
      end

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    {:noreply, state}
  end

  defp poll_rate() do
    Application.get_env(:message_queue, :rate_limit_interval_milliseconds)
  end

  defp manual_enqueue() do
    Application.get_env(:message_queue, :manual_enqueue)
  end

  defp next_timer(queue, rate \\ 1) do
    # can also use :timer.send_interval, the trade-off being potentially not
    # being finished before the next tick, this way there could be drift but you
    # guarantee one tick finishes before the next.  However, these would be
    # concerns for real-world situations, not this toy example.
    unless manual_enqueue() do
      Process.send_after(self(), {:handle_next, queue}, rate)
    end
  end
end
