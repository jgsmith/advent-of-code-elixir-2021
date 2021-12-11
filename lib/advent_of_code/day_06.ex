defmodule AdventOfCode.Day06 do
  def part1(args) do
    args
    |> parse_input()
    |> ticks(80)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> ticks(256)
    |> Map.values()
    |> Enum.sum()
  end

  def parse_input(source) do
    source
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.group_by(fn x -> x end)
    |> Enum.map(fn {k, vs} -> {k, Enum.count(vs)} end)
    |> Enum.into(%{})
  end

  def ticks(ages, 0), do: ages
  def ticks(ages, n), do: ticks(tick(ages), n - 1)

  def tick(ages) do
    {new_fish, new_ages} = Enum.reduce(ages, {0, %{}}, &age_fish/2)

    Map.put(new_ages, 8, new_fish)
  end

  def age_fish({0, count}, {new_fish, new_ages}),
    do: {new_fish + count, Map.update(new_ages, 6, count, fn old_count -> old_count + count end)}

  def age_fish({n, count}, {new_fish, new_ages}),
    do: {new_fish, Map.update(new_ages, n - 1, count, fn old_count -> old_count + count end)}
end
