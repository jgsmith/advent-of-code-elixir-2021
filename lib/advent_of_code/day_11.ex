defmodule AdventOfCode.Day11 do
  @type point :: {integer, integer}
  @type octopuses :: {integer, map}

  @spec part1(binary) :: non_neg_integer
  def part1(args) do
    args
    |> parse_input()
    |> start()
    |> ticks(100)
    |> flash_count()
  end

  @spec part2(binary) :: integer
  def part2(args) do
    args
    |> parse_input()
    |> start()
    |> tick_until_all_flash()
  end

  @spec parse_input(binary) :: map
  def parse_input(source) do
    source
    |> String.trim()
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      Enum.map(line, fn {power, x} -> {{x, y}, power} end)
    end)
    |> Enum.into(%{})
  end

  @spec parse_line(binary) :: [{integer, integer}]
  def parse_line(line) do
    line
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
  end

  @spec tick_until_all_flash(octopuses, integer) :: integer
  def tick_until_all_flash(octopuses, count \\ 0) do
    new_octopuses = tick(octopuses)

    if all_flashed?(new_octopuses) do
      count + 1
    else
      tick_until_all_flash(new_octopuses, count + 1)
    end
  end

  @spec all_flashed?(octopuses) :: boolean
  def all_flashed?({_, map}) do
    map
    |> Map.values()
    |> Enum.all?(fn x -> x == 0 end)
  end

  @spec start(map) :: octopuses
  def start(map), do: {0, map}

  @spec flash_count(octopuses) :: non_neg_integer
  def flash_count({count, _}), do: count

  @spec ticks(octopuses, non_neg_integer) :: octopuses
  def ticks(octopuses, count)
  def ticks(octopuses, 0), do: octopuses

  def ticks(octopuses, count) do
    octopuses
    |> tick()
    |> ticks(count - 1)
  end

  @spec tick(octopuses) :: octopuses
  def tick(octopuses) do
    octopuses
    |> power_up()
    |> process_flashes()
    |> reset_power()
  end

  @spec power_up(octopuses) :: octopuses
  def power_up({count, map}) do
    {count,
     map
     |> Enum.map(fn {point, power} -> {point, power + 1} end)
     |> Enum.into(%{})}
  end

  @spec reset_power(octopuses) :: octopuses
  def reset_power({count, map}) do
    {count,
     map
     |> Enum.map(fn {point, power} -> {point, if(power == -1, do: 0, else: power)} end)
     |> Enum.into(%{})}
  end

  def find_flashes({_, map}) do
    map
    |> Enum.filter(fn {_, power} -> power > 9 end)
    |> Enum.map(&elem(&1, 0))
  end

  @spec process_flashes(octopuses) :: octopuses
  def process_flashes({count, map} = octopuses) do
    # to process map, see which locations are equal to 10 - they flash and their neighbors are incremented by 1
    # repeat until no more flashes
    flash_points = find_flashes(octopuses)

    if Enum.empty?(flash_points) do
      octopuses
    else
      flash_neighbors = Enum.flat_map(flash_points, &neighbors(&1, octopuses))

      octopuses
      |> add_flash_count(Enum.count(flash_points))
      |> add_power_to_points(flash_neighbors)
      |> reset_flashed(flash_points)
      |> process_flashes()
    end
  end

  def add_flash_count({count, map}, more), do: {count + more, map}

  def reset_flashed({count, map}, points) do
    {count, Enum.reduce(points, map, fn point, map -> Map.put(map, point, -1) end)}
  end

  def add_power_to_points({count, map}, points) do
    new_map =
      points
      |> Enum.reduce(map, fn point, map ->
        Map.update!(map, point, fn power -> if power >= 0, do: power + 1, else: power end)
      end)

    {count, new_map}
  end

  @spec neighbors(point, octopuses) :: [point]
  def neighbors({x, y}, {_, map}) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
    |> Enum.filter(fn point -> Map.has_key?(map, point) end)
  end
end
