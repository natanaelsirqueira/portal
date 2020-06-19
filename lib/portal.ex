defmodule Portal do
  @moduledoc """
  Defines a struct to represent a Portal.
  """

  @type t :: %Portal{left: atom, right: atom}

  defstruct [:left, :right]

  @doc """
  Shoots a new door with the given `color`.

  ## Examples

      iex> {:ok, pid} = Portal.shoot(:blue)
      iex> is_pid(pid)
      true
  """
  @spec shoot(atom) :: DynamicSupervisor.on_start_child
  def shoot(color) when is_atom(color) do
    case DynamicSupervisor.start_child(Portal.DoorSupervisor, {Portal.Door, color}) do
      {:error, {:already_started, pid}} ->
        Portal.Door.reset(pid)

        {:ok, pid}

      other ->
        other
    end
  end

  @doc """
  Create a portal between doors `left` and `right`.

  Starts transfer by adding all `data` to the door on the left.

  ## Examples

  After shooting doors `:orange` and `:blue`,
  you should be able to start transfering data between them like the following:

      iex> Portal.shoot(:orange)
      iex> Portal.shoot(:blue)
      iex> portal = Portal.transfer(:orange, :blue, [1, 2, 3])
      #Portal<
          :orange <=> :blue
        [1, 2, 3] <=> []
      >
      iex> portal
      %Portal{left: :orange, right: :blue}
  """
  @spec transfer(left :: atom, right :: atom, data :: list) :: t
  def transfer(left, right, data) when is_atom(left) and is_atom(right) and is_list(data) do
    for item <- data do
      Portal.Door.push(left, item)
    end

    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given `portal`.

  ## Examples

  Assuming the `:left` door of a portal contains `[1, 2, 3]` as its data,
  this function will pop the element `3` and push it to the `:right` door of the portal.

      iex> Portal.shoot(:orange)
      iex> Portal.shoot(:blue)
      iex> portal = Portal.transfer(:orange, :blue, [1, 2, 3])
      iex> Portal.push_right(portal)
      #Portal<
        :orange <=> :blue
         [1, 2] <=> [3]
      >
  """
  @spec push_right(t) :: t
  def push_right(portal) do
    push(portal, :left, :right)
  end

  @doc """
  Pushes data to the left in the given `portal`.

  This function is very similar to `push_right/1` in the sense that a single item
  will be transfered from the `:right` door to the `:left` door of the `portal`.

      iex> Portal.shoot(:orange)
      iex> Portal.shoot(:blue)
      iex> portal = Portal.transfer(:orange, :blue, [1, 2, 3])
      iex> Portal.push_right(portal)
      iex> Portal.push_left(portal)
      #Portal<
          :orange <=> :blue
        [1, 2, 3] <=> []
      >
  """
  @spec push_left(t) :: t
  def push_left(portal) do
    push(portal, :right, :left)
  end

  defp push(portal, from, to) do
    # See if we can pop data from the first door. If so, push the
    # popped data to the other door. Otherwise, do nothing.
    case portal |> Map.fetch!(from) |> Portal.Door.pop() do
      :error -> :ok
      {:ok, h} -> portal |> Map.fetch!(to) |> Portal.Door.push(h)
    end

    portal
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    String.trim("""
    #Portal<
      #{String.pad_leading(left_door, max)} <=> #{right_door}
      #{String.pad_leading(left_data, max)} <=> #{right_data}
    >
    """)
  end
end
