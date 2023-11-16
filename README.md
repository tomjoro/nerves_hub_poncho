# FIRST COMMIT

## Setup Nerves 

https://hexdocs.pm/nerves/installation.html

* MacOS Easy
* Linux Fairly easy
* Windows Good luck

## Book example

* Building a weather station with Elixir and Nerves

## This project



mkdir sensor_hub_poncho

cd sensor_hub_poncho

mix nerves.new sensor_hub

cd sensor_hub

export MIX_TARGET=rpi3

mix deps.get

## Linux image being downloaded
Take a look at mix.exs - this are the targets and what the MIX_TARGET does

mix firmware


## Put SD in

mix burn

## Pop out and put in device

## SSH works over USB, but can also work over Wifi

ssh nerves.local

```
hostname()
ls()
```

# Chapter2

https://github.com/elixir-circuits/circuits_i2c/blob/v2.0.1/README.md#L1
https://hexdocs.pm/circuits_i2c/readme.html

```
    # Dependencies for all targets
    {:circuits_i2c, "~> 1.1.0"},
```

```
alias Circuits.I2C
I2C.detect_devices()
sensor = 0x48
command = <<0>>
byte_size = 2
{:ok, i2c_ref} = I2C.open("i2c-1")
<<value::little-16>> = I2C.write_read!(i2c_ref, sensor, command, 2) <<1, 0>>
value |> inspect(base: :binary)
config = 0b0001100000000000
Circuits.I2C.write(i2c_ref, sensor, <<0, config::little-16>>)

iex(1)> 
Circuits.I2C
iex(2)> 
iex(2)>  72
iex(3)>  <<0>>
iex(4)> byte_size = 2
Capturing Sensor Data • 25
 report erratum • discuss
2
iex(5)> {:ok, i2c_ref} = I2C.open("i2c-1") {:ok, #Reference<0.1635386997.268828675.62058>}
iex(6)> <<value::little-16>> = I2C.write_read!(i2c_ref, sensor, command, 2) <<1, 0>>
iex(7)> value |> inspect(base: :binary) "0b1"
<<value::little-16>> = I2C.write_read!(i2c_ref, sensor, command, 2) <<0, 24>>
value |> inspect(base: :binary)
light_reading = 4
<<value::little-16>> = Circuits.I2C.write_read!(i2c_ref, sensor, <<light_reading>>, 2)
value
<<value::little-16>> = Circuits.I2C.write_read!(i2c_ref, sensor, <<light_reading>>, 2)
value
# Put your hand over the light sensor and check value
<<value::little-16>> = Circuits.I2C.write_read!(i2c_ref, sensor, <<light_reading>>, 2)
value

# Convert to lumens
measure_light = fn i2c, address ->
    <<value::little-16>> = I2C.write_read!(i2c, address, <<4>>, 2) ...(17)> value * 0.2304
end

measure_light.(i2c_ref, sensor)
```


# Chapter3 

`# Lets get a couple of sensors, one from git, and the other from clone

cd ..
git clone git@github.com:mmmries/ads1115.git
git clone git@github.com:elixir-sensors/bmp280.git

Add to mix file

{:ads1115, path: "../ads1115", targets: @all_targets},
{:bmp280, path: "../bmp280", targets: @all_targets}

`I had to update the AS1115 circuits_i2c to a 1.0 version!

{:bmp280, "~> 0.2.12",  targets: @all_targets}

iex> {:ok, bmp} = BMP280.start_link(bus_name: "i2c-1", bus_address: 0x77)
{:ok, #PID<0.29929.0>}
iex> BMP280.measure(bmp)
{:ok,
 %BMP280.Measurement{
   altitude_m: 138.96206905098805,
   dew_point_c: 2.629181073094435,
   gas_resistance_ohms: 5279.474749704044,
   humidity_rh: 34.39681642351278,
   pressure_pa: 100818.86273677988,
   temperature_c: 18.645856498100876,
   timestamp_ms: 885906
 }}



