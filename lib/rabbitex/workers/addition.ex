defmodule Worker.Addition do
  use GenServer

  def child_spec([]),
    do: child_spec(mode: :fast)

  def child_spec(mode) when is_atom(mode),
    do: child_spec(mode: mode)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :abobrinha, [opts]}
    }
  end

  def abobrinha(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(mode: :fast), do: {:ok, :fast}
  def init(_), do: {:ok, :slow}

  @spec add(maybe_improper_list) :: :ok
  def add(nums) when is_list(nums) do
    nums = Enum.map(nums, &String.to_integer/1)
    GenServer.cast(__MODULE__, {:add, nums})
  end

  def handle_cast({:add, nums}, state) do
    publisher = Process.whereis(Rabbitex.Consumer)

    case state do
      :fast ->
        send(publisher, {:result, Enum.sum(nums)})

      :slow ->
        Process.send_after(
          publisher,
          {:result, Enum.sum(nums)},
          :timer.seconds(2)
        )
    end

    {:noreply, state}
  end
end
