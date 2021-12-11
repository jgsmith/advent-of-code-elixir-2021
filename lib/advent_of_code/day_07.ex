defmodule AdventOfCode.Day07 do
  def part1(args) do
    crabs = parse_input(args)
    find_cheapest_position(:constant_cost, find_crab_range(crabs), crabs)
  end

  def part2(args) do
    crabs = parse_input(args)
    find_cheapest_position(:linear_cost, find_crab_range(crabs), crabs)
  end

  def parse_input(source) do
    source
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def fuel_cost(:constant_cost, position, crabs) do
    crabs
    |> Enum.map(fn crab -> abs(position - crab) end)
    |> Enum.sum()
  end

  def fuel_cost(:linear_cost, position, crabs) do
    crabs
    |> Enum.map(fn crab ->
      diff = abs(position - crab)
      diff * (diff + 1) / 2
    end)
    |> Enum.sum()
  end

  def find_crab_range(crabs) do
    {least, most} = Enum.min_max(crabs)
    Range.new(least, most)
  end

  def find_cheapest_position(cost_type, range, crabs) do
    range
    |> Enum.map(fn position -> {position, fuel_cost(cost_type, position, crabs)} end)
    |> Enum.sort_by(fn {_, cost} -> cost end)
    |> List.first()
  end
end
