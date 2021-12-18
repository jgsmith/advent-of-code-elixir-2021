defmodule AdventOfCode.Day14 do
  def part1(args) do
    {start, rules} = parse_input(args)

    counts =
      start
      |> start_grinding()
      |> apply_rules(rules, 10)
      |> count_letters()

    {min_count, max_count} = Enum.min_max(Map.values(counts))
    max_count - min_count
  end

  def part2(args) do
    {start, rules} = parse_input(args)

    counts =
      start
      |> start_grinding()
      |> apply_rules(rules, 40)
      |> count_letters()

    {min_count, max_count} = Enum.min_max(Map.values(counts))
    max_count - min_count
  end

  def parse_input(source) do
    [start | lines] =
      source
      |> String.trim()
      |> String.split(~r{\s*\n\s*}, trim: true)

    {String.split(start, "", trim: true), Enum.into(Enum.map(lines, &parse_rule/1), %{})}
  end

  def parse_rule(line) do
    [_, left, right, insertion] = Regex.run(~r{([A-Z])([A-Z])\s*->\s*([A-Z])}, line)
    {{left, right}, insertion}
  end

  def start_grinding(start) do
    start
    |> Enum.zip(Enum.drop(start, 1))
    |> Enum.reduce(%{}, fn pair, counts -> Map.update(counts, pair, 1, fn c -> c + 1 end) end)
  end

  def apply_rules(stream, rules, count \\ 0)

  def apply_rules(stream, _, 0), do: stream

  def apply_rules(mapping, rules, count) do
    mapping
    |> Enum.flat_map(fn {{left, right} = pair, count} ->
      middle_letter = Map.get(rules, pair)
      [{{left, middle_letter}, count}, {{middle_letter, right}, count}]
    end)
    |> Enum.reduce(%{}, fn {pair, count}, counts ->
      Map.update(counts, pair, count, fn c -> c + count end)
    end)
    |> apply_rules(rules, count - 1)
  end

  def count_letters(stream) do
    Enum.reduce(stream, %{}, fn {{_, right}, count}, counts ->
      Map.update(counts, right, count, fn c -> c + count end)
    end)
  end
end
