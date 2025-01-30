defmodule OTP.GenericStateMachines.Gate do
  use GenStateMachine

  @timeouts %{
    :open => 3_000,
    :close => 3_000,
    :stay_open => 10_000
  }

  # Public API

  def start_link(_ \\ :ok) do
    GenStateMachine.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def approach do
    GenStateMachine.call(__MODULE__, :approach)
  end

  def unlock do
    GenStateMachine.cast(__MODULE__, :unlock)
  end

  # Callbacks

  def init(:ok) do
    IO.puts("Gate is closed.")
    {:ok, :closed, :ok}
  end

  def handle_event(:info, :timeout, state, _) do
    next_state =
      case state do
        :open -> :closing
        :closing -> :closed
        :closed -> :opening
        :opening -> :open
      end

    IO.puts("Gate is #{next_state}.")
    case next_state do
      :closing -> Process.send_after(self(), :timeout, @timeouts[:close])
      :opening -> Process.send_after(self(), :timeout, @timeouts[:open])
      :open -> Process.send_after(self(), :timeout, @timeouts[:open])
      _ -> nil
    end
    {:next_state, next_state, :ok}
  end

  def handle_event({:call, from}, :approach, state, _) do
    reply =
      case state do
        :open -> "You may pass."
        state -> "Gate is #{state}. Please wait."
      end
    {:keep_state_and_data, [{:reply, from, reply}]}
  end

  def handle_event(:cast, :unlock, state, _) do
    case state do
      :closed -> Process.send_after(self(), :timeout, @timeouts[:open])
      :open -> IO.puts("Gate is already open.")
      _ -> IO.puts("Gate is #{state}. PLease wait.")
    end
    {:next_state, :opening, :ok}
  end
end
