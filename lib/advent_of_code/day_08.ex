defmodule AdventOfCode.Day08 do
  def part1(args) do
    displays = parse_input(args)

    count_outputs(displays, 1) + count_outputs(displays, 4) + count_outputs(displays, 7) +
      count_outputs(displays, 8)
  end

  def part2(args) do
    displays = parse_input(args)

    displays
    |> Enum.map(&interpret_display/1)
    |> Enum.sum()
  end

  def parse_input(source) do
    source
    |> String.trim()
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [left, right] =
      line
      |> String.trim()
      |> String.split(~r{\s*\|\s*}, parts: 2, trim: true)

    {parse_digits(left), parse_digits(right)}
  end

  def parse_digits(bit) do
    bit
    |> String.trim()
    |> String.split(~r{\s+}, trim: true)
    |> Enum.map(fn s -> s |> String.split("") |> Enum.sort() |> Enum.join("") end)
  end

  def count_outputs(displays, digit) do
    displays
    |> Enum.map(fn {_, outputs} -> count_digits(outputs, digit) end)
    |> Enum.sum()
  end

  def count_digits(outputs, 1), do: Enum.count(outputs, fn x -> String.length(x) == 2 end)
  def count_digits(outputs, 4), do: Enum.count(outputs, fn x -> String.length(x) == 4 end)
  def count_digits(outputs, 7), do: Enum.count(outputs, fn x -> String.length(x) == 3 end)
  def count_digits(outputs, 8), do: Enum.count(outputs, fn x -> String.length(x) == 7 end)

  def interpret_display({examples, output}) do
    one = Enum.find(examples, fn x -> String.length(x) == 2 end) |> String.split("", trim: true)
    four = Enum.find(examples, fn x -> String.length(x) == 4 end) |> String.split("", trim: true)
    seven = Enum.find(examples, fn x -> String.length(x) == 3 end) |> String.split("", trim: true)
    eight = Enum.find(examples, fn x -> String.length(x) == 7 end) |> String.split("", trim: true)

    digits =
      examples
      |> Enum.filter(fn x -> String.length(x) not in [2, 3, 4, 7] end)
      |> Enum.map(&classify_digit(&1, one, four, seven))
      |> Enum.into(%{})
      |> Map.put(Enum.join(one, ""), 1)
      |> Map.put(Enum.join(four, ""), 4)
      |> Map.put(Enum.join(seven, ""), 7)
      |> Map.put(Enum.join(eight, ""), 8)

    [a, b, c, d] = Enum.map(output, fn x -> Map.get(digits, x) end)
    a * 1000 + b * 100 + c * 10 + d
  end

  def classify_digit(pattern, one, four, seven) do
    length = String.length(pattern)
    shared_with_one = Enum.count(one, fn l -> String.contains?(pattern, l) end)
    shared_with_four = Enum.count(four, fn l -> String.contains?(pattern, l) end)
    shared_with_seven = Enum.count(seven, fn l -> String.contains?(pattern, l) end)

    case {length, shared_with_one, shared_with_four, shared_with_seven} do
      {5, 1, 3, 2} -> {pattern, 5}
      {5, 1, 2, 2} -> {pattern, 2}
      {5, 2, 3, 3} -> {pattern, 3}
      {6, 2, 4, 3} -> {pattern, 9}
      {6, 1, 3, 2} -> {pattern, 6}
      {6, 2, 3, 3} -> {pattern, 0}
    end
  end
end
