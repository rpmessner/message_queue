defmodule MessageQueue.RateLimiter do
  use GenServer

  @table_name :message_queue_rate_limiter

  def send_message(queue, message) do
    case lookup_queue(queue) do
      nil ->
        set_queue(queue, [message])
        start_timer(queue)

      messages ->
        set_queue(queue, messages ++ [message])
    end
  end

  def state() do
    :ets.tab2list(@table_name) |> Enum.into(%{})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  defp set_queue(queue, messages) do
    :ets.insert(@table_name, {queue, messages})
  end

  defp lookup_queue(queue) do
    case :ets.lookup(@table_name, queue) do
      [{^queue, messages}] -> messages || []
      _ -> nil
    end
  end

  def start_timer(queue) do
    GenServer.cast(__MODULE__, {:start_timer, queue})
  end

  @impl true
  def init(_opts) do
    create_table()

    {:ok, %{}}
  end

  @impl true
  def handle_cast({:start_timer, queue}, state) do
    next_timer(queue)

    {:noreply, state}
  end

  @impl true
  def handle_info({:handle_next, queue}, state) do
    handle_next(queue)

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    {:noreply, state}
  end

  def handle_next(queue) do
    case lookup_queue(queue) do
      [message | rest] ->
        # in real world examples this would probably end up being
        # a tuple of values we could feed into apply()
        IO.write("#{queue}: #{message}\n")

        set_queue(queue, rest)
        next_timer(queue, poll_rate())

      [] ->
        :ets.delete(@table_name, queue)

      nil -> 
        nil
    end
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

  defp create_table do
    :ets.new(@table_name, [
      :set,
      :public,
      :named_table,
      read_concurrency: true,
      write_concurrency: true
    ])
  end
end
