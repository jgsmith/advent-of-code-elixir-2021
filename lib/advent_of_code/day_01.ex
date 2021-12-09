defmodule AdventOfCode.Day01 do
  def part1(args) when is_list(args) do
    count_increases(args)
  end

  def part1(filename) when is_binary(filename) do
    filename
    |> from_file()
    |> part1()
  end

  def part2([_ | [_ | c] = b] = a) when is_list(a) do
    [a, b, c]
    |> Enum.zip()
    |> Enum.map(fn {x, y, z} -> x + y + z end)
    |> count_increases()
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
    |> String.split(~r{\s+})
    |> Enum.map(&String.to_integer/1)
  end

  def count_increases([first | stream]) do
    stream
    |> Enum.reduce({first, 0}, fn item, {previous, count} ->
      if item > previous do
        {item, count + 1}
      else
        {item, count}
      end
    end)
    |> elem(1)
  end
end
