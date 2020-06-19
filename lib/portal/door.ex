defmodule Portal.Door do
  @moduledoc """
  Implements an `Agent` to store data for a `Portal` door.
  """

  use Agent

  @doc """
  Starts a door with the given `color`.

  The color is given as a name so we can identify
  the door by color name instead of using a PID.
  """
  @spec start_link(atom) :: Agent.on_start
  def start_link(color) do
    Agent.start_link(fn -> [] end, name: color)
  end

  @doc """
  Get the data currently in the `door`.
  """
  @spec get(Agent.agent) :: list
  def get(door) do
    Agent.get(door, fn list -> list end)
  end

  @doc """
  Pushes `value` into the door.
  """
  @spec push(Agent.agent, term) :: :ok
  def push(door, value) do
    Agent.update(door, fn list -> [value | list] end)
  end

  @doc """
  Pops a value from the `door`.

  Returns `{:ok, value}` if there is a value
  or `:error` if the hole is currently empty.
  """
  @spec pop(Agent.agent) :: any
  def pop(door) do
    Agent.get_and_update(door, fn
      [] -> {:error, []}
      [h | t] -> {{:ok, h}, t}
    end)
  end

  @doc """
  Removes all data currently in the `door`.
  """
  @spec reset(Agent.agent) :: :ok
  def reset(door) do
    Agent.update(door, fn _ -> [] end)
  end
end
