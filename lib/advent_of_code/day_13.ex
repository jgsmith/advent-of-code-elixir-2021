defmodule AdventOfCode.Day13 do
  def part1(args) do
    {points, [first_instruction | _] = instructions} = parse_input(args)
    IO.inspect(instructions)

    points
    |> run_instructions([first_instruction])
    |> Enum.count()
  end

  def part2(args) do
    {points, instructions} = parse_input(args)

    points
    |> run_instructions(instructions)
    |> draw_points()
  end

  def parse_input(source) do
    source
    |> String.trim()
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> gather_points()
    |> gather_instructions()
  end

  def gather_points([line | lines], points \\ []) do
    case Regex.run(~r{(\d+),(\d+)}, line) do
      [_, x, y] ->
        gather_points(lines, [{String.to_integer(x), String.to_integer(y)} | points])

      nil ->
        {[line | lines], points}
    end
  end

  def gather_instructions({lines, points}), do: gather_instructions(lines, points, [])

  def gather_instructions([], points, instructions), do: {points, Enum.reverse(instructions)}

  def gather_instructions([line | lines], points, instructions) do
    case Regex.run(~r{fold along ([xy])=(\d+)}, line) do
      [_, axis, distance] ->
        gather_instructions(lines, points, [{axis, String.to_integer(distance)} | instructions])

      nil ->
        gather_instructions(lines, points, instructions)
    end
  end

  def run_instructions(points, []), do: points

  def run_instructions(points, [{axis, offset} | instructions]) do
    points
    |> Enum.map(&reflect(&1, axis, offset))
    |> Enum.uniq()
    |> run_instructions(instructions)
  end

  def reflect({x, y}, "x", offset) do
    if x > offset do
      {offset - (x - offset), y}
    else
      {x, y}
    end
  end

  def reflect({x, y}, "y", offset) do
    if y > offset do
      {x, offset - (y - offset)}
    else
      {x, y}
    end
  end

  def draw_points(points) do
    points
    |> Enum.group_by(fn {_, y} -> y end)
    |> Enum.map(&draw_line/1)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def draw_line({_, points}) do
    xs = Enum.map(points, &elem(&1, 0))
    max_x = Enum.max(xs)

    0..max_x
    |> Enum.map(fn x -> if x in xs, do: "*", else: " " end)
    |> Enum.join("")
  end
end
