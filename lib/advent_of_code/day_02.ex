defmodule AdventOfCode.Day02 do
  def part1(args) when is_list(args) do
    args
    |> Enum.map(&parse_command/1)
    |> Enum.reduce({0, 0}, &do_command/2)
  end

  def part1(filename) when is_binary(filename) do
    filename
    |> from_file()
    |> part1()
  end

  def part2(args) when is_list(args) do
    args
    |> Enum.map(&parse_command/1)
    |> Enum.reduce({0, 0, 0}, &do_command/2)
  end

  def part2(filename) when is_binary(filename) do
    filename
    |> from_file()
    |> part2()
  end

  def from_file(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(~r{\s*\n\s*})
  end

  def parse_command(command) do
    [word, number] = String.split(command, ~r{\s+}, parts: 2)
    {String.to_atom(word), String.to_integer(number)}
  end

  def do_command({:forward, n}, {horizontal, depth}), do: {horizontal + n, depth}
  def do_command({:down, n}, {horizontal, depth}), do: {horizontal, depth + n}
  def do_command({:up, n}, {horizontal, depth}), do: {horizontal, depth - n}

  # now the commands that manage aim
  def do_command({:forward, n}, {horizontal, depth, aim}),
    do: {horizontal + n, depth + aim * n, aim}

  def do_command({:down, n}, {horizontal, depth, aim}), do: {horizontal, depth, aim + n}
  def do_command({:up, n}, {horizontal, depth, aim}), do: {horizontal, depth, aim - n}
end
