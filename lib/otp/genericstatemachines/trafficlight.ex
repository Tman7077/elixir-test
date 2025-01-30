defmodule OTP.GenericStateMachines.TrafficLight do
  use GenStateMachine

  @timeouts %{
    :green => 10_000,
    :yellow => 2_000,
    :red => 10_000
  }

  # Public API
  def start_link(_ \\ :ok) do
    GenStateMachine.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def can_i_drive do
    GenStateMachine.call(__MODULE__, :drive)
  end

  # Callbacks

  def init(:ok) do
    IO.puts("Traffic light is green.")
    Process.send_after(self(), :timeout, @timeouts[:green])
    {:ok, :green, :ok}
  end

  def handle_event(:info, :timeout, state, _) do
    next_state =
      case state do
        :green -> :yellow
        :yellow -> :red
        :red -> :green
      end

    IO.puts("Traffic light is #{next_state}.")
    Process.send_after(self(), :timeout, @timeouts[next_state])
    {:next_state, next_state, :ok}
  end

  def handle_event({:call, from}, :drive, state, _) do
    reply =
      case state do
        :green -> :yes
        _ -> :no
      end

    # IO.puts("#{reply}")
    {:keep_state_and_data, [{:reply, from, reply}]}
  end
end
