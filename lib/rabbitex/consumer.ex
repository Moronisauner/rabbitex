defmodule Rabbitex.Consumer do
  use GenServer

  require Logger

  alias AMQP.{
    Basic,
    Channel,
    Connection,
    Exchange,
    Queue
  }

  @uri "amqp://localhost"
  @exchange "operator"

  @default [input: "entrada", output: "saida"]

  defmodule State do
    defstruct [:conn, :chan, :input, :output, :consumer_tag, workers: []]
  end

  def child_spec([]), do: child_spec(@default)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker
    }
  end

  def init(opts) do
    {:ok, conn} = Connection.open(@uri)
    {:ok, chan} = Channel.open(conn)

    setup_rabbitmq(chan, opts)

    {:ok, _} = Basic.consume(chan, opts[:input])

    {:ok,
     %State{
       conn: conn,
       chan: chan,
       input: opts[:input],
       output: opts[:output]
     }}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def handle_info(
        {:basic_consume_ok, %{consumer_tag: consumer_tag}},
        %State{consumer_tag: _any} = state
      ) do
    {:noreply, %State{state | consumer_tag: consumer_tag}}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag}}, %State{} = state) do
    with :ok <- route_message(payload) do
      Basic.ack(state.chan, tag)
    end

    {:noreply, state}
  end

  def handle_info({:result, result}, %State{} = state) do
    Basic.publish(
      state.chan,
      @exchange,
      state.output,
      "#{inspect(result)}"
    )

    {:noreply, state}
  end

  defp route_message(payload) do
    payload
    |> String.downcase()
    |> String.split()
    |> case do
      ["add" | nums] -> Worker.Addition.add(nums)
    end
  end

  defp setup_rabbitmq(chan, opts) do
    {:ok, _} = Queue.declare(chan, opts[:input], durable: true)
    {:ok, _} = Queue.declare(chan, opts[:output], durable: true)

    :ok = Exchange.fanout(chan, @exchange, durable: true)
    :ok = Queue.bind(chan, opts[:output], @exchange, routing_key: "output")
  end
end
