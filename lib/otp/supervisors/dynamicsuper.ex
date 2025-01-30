defmodule OTP.Supervisors.DynamicSuper do
  use DynamicSupervisor

  def start_link(_ \\ :ok) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    start_child_by_name(:child1)
    start_child_by_name(:child2)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child_by_name(name) do
    DynamicSupervisor.start_child(__MODULE__, {OTP.GenericServers.Child, name})
  end
end
