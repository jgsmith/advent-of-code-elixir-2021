defmodule AdventOfCode.Day05 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.filter(fn line -> horizontal_line?(line) or vertical_line?(line) end)
    |> draw_map()
    |> Map.values()
    |> Enum.count(fn count -> count > 1 end)
  end

  def part2(args) do
    args
    |> parse_input()
    |> draw_map()
    |> Map.values()
    |> Enum.count(fn count -> count > 1 end)
  end

  def parse_input(source) do
    source
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [start_x, start_y, end_x, end_y] =
      ~r{(\d+),(\d+)\s*->\s*(\d+),(\d+)}
      |> Regex.run(line)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer/1)

    {{start_x, start_y}, {end_x, end_y}}
  end

  def horizontal_line?({{_, y}, {_, y}}), do: true
  def horizontal_line?(_), do: false

  def vertical_line?({{x, _}, {x, _}}), do: true
  def vertical_line?(_), do: false

  def draw_map(lines) do
    lines
    |> Enum.reduce(%{}, &draw_line/2)
  end

  def draw_line({{start_x, y}, {end_x, y}}, map) do
    {first, last} = Enum.min_max([start_x, end_x])

    Enum.reduce(Range.new(first, last), map, fn x, map -> add_point({x, y}, map) end)
  end

  def draw_line({{x, start_y}, {x, end_y}}, map) do
    {first, last} = Enum.min_max([start_y, end_y])

    Enum.reduce(Range.new(first, last), map, fn y, map -> add_point({x, y}, map) end)
  end

  def draw_line({point, point}, map), do: add_point(point, map)

  def draw_line({{start_x, start_y}, {end_x, end_y}}, map) do
    delta_x = if start_x < end_x, do: 1, else: -1
    delta_y = if start_y < end_y, do: 1, else: -1

    draw_line(
      {{start_x + delta_x, start_y + delta_y}, {end_x, end_y}},
      add_point({start_x, start_y}, map)
    )
  end

  def add_point(point, map), do: Map.update(map, point, 1, fn count -> count + 1 end)
end
