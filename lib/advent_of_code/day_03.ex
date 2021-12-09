defmodule AdventOfCode.Day03 do
  def part1([first | _] = args) when is_list(args) do
    total_lines = Enum.count(args)

    number_size = String.length(first)
    counters = List.duplicate(0, number_size)

    args
    |> Enum.reduce(counters, &account_for_digits/2)
    |> find_gamma_and_epsilon(total_lines)
  end

  def part1(filename) when is_binary(filename) do
    filename
    |> from_file()
    |> part1()
  end

  def part2([first | _] = args) do
    number_size = String.length(first)
    counters = List.duplicate(0, number_size)

    {find_rating(args, :oxygen, number_size, counters),
     find_rating(args, :co2_scrubber, number_size, counters)}
  end

  def part2(filename) when is_binary(filename) do
    filename
    |> from_file()
    |> part2()
  end

  def find_rating(args, type, number_size, counters, pos \\ 0)
  def find_rating([rating], _, _, _, _), do: String.to_integer(rating, 2)

  def find_rating(args, type, number_size, counters, pos) do
    total_lines = Enum.count(args)
    bit_counts = Enum.reduce(args, counters, &account_for_digits/2)
    count_we_care_about = Enum.at(bit_counts, pos)

    bit_we_keep =
      if type == :oxygen do
        if count_we_care_about * 2 >= total_lines, do: "1", else: "0"
      else
        if count_we_care_about * 2 < total_lines, do: "1", else: "0"
      end

    args
    |> Enum.filter(fn number -> String.at(number, pos) == bit_we_keep end)
    |> find_rating(type, number_size, counters, pos + 1)
  end

  def from_file(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(~r{\s*\n\s*})
  end

  def account_for_digits(string, counters) do
    string
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(counters, fn {digit, pos}, acc ->
      if digit == "1" do
        List.replace_at(acc, pos, Enum.at(acc, pos) + 1)
      else
        acc
      end
    end)
  end

  def find_gamma_and_epsilon(counters, total_lines) do
    {gamma, epsilon} =
      counters
      |> Enum.reduce({"", ""}, fn count, {g, e} ->
        if count * 2 > total_lines do
          {"#{g}1", "#{e}0"}
        else
          {"#{g}0", "#{e}1"}
        end
      end)

    {String.to_integer(gamma, 2), String.to_integer(epsilon, 2)}
  end
end
