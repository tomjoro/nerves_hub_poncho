defmodule Publisher do
  use GenServer, restart: :transient, shutdown: 10_000
  require Logger

  def start_link(options \\ %{}) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  def init(options) do
    sensor = SensorHub.Sensor.new(BMP280)

    state = %{ sensor: sensor}

    Logger.info("Sensor initialized")
    :timer.send_interval(5000, self(), :measure)

    {:ok, state}
  end


  @impl true
  def handle_info(:measure, state) do
    measurement = SensorHub.Sensor.measure(state.sensor)
    Logger.info("Measurement: #{inspect(measurement)}")
    {:noreply, state}
  end
end
