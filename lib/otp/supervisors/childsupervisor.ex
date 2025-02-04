defmodule OTP.Supervisors.ChildSupervisor do
  use Supervisor

  def start_link(_ \\ :ok) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      %{
        id: :child1,
        start: {OTP.GenericServers.ExampleChild, :start_link, [:child1]}
      },
      %{
        id: :child2,
        start: {OTP.GenericServers.ExampleChild, :start_link, [:child2]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
