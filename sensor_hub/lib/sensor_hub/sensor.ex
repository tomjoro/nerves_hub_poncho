defmodule SensorHub.Sensor do

  defstruct [:name, :fields, :read, :convert, :mergable]

  def new(name) do
    %__MODULE__{
      read: read_fn(name),
      convert: convert_fn(name),
      fields: fields(name),
      name: name,
    }
  end

  def fields(BMP280), do: [:temperature_c]
  def fields(ADS1015), do: [:voltage]

  def read_fn(BMP280), do: fn() -> BMP280.measure(BMP280) end  # gen_server
  def read_fn(ADS1015), do: fn() -> ADS1015.measure() end   # gain settings

  def convert_fn(BMP280) do
    fn reading ->
      case reading do
        {:ok, measurement} ->
          Map.take(measurement, [:temperature_c])
        _ ->
          %{}
      end
    end
  end

  def convert_fn(ADS1015) do
    fn reading ->
      case reading do
        {:ok, measurement} ->
          Map.take(measurement, [:voltage])
        _ ->
          %{}
      end
    end
  end

  def measure(sensor) do
    sensor.read.()
    |> sensor.convert.()
  end

end
