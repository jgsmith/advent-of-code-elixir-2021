defmodule AdventOfCode.Day18 do
  def part1(args) do
    args
    |> parse_input()
    |> sum()
    |> magnitude()
  end

  def part2(args) do
    numbers = parse_input(args)

    numbers
    |> Enum.flat_map(fn n ->
      Enum.map(numbers, fn m ->
        if n != m, do: magnitude(sum([m, n])), else: 0
      end)
    end)
    |> Enum.max()
  end

  def parse_input(source) do
    source
    |> String.trim()
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse_line/1)
  end

  @spec parse_line(binary, list) :: [integer | :up | :down | list]
  def parse_line(line, acc \\ [])
  # [\d+,\d+] => [m, n]
  # \d => m
  # [ => :down
  # ] => :up
  def parse_line("", acc), do: Enum.reverse(acc)
  def parse_line(<<"[", rest::binary>>, acc), do: parse_line(rest, [:down | acc])
  def parse_line(<<"]", rest::binary>>, acc), do: parse_line(rest, [:up | acc])
  def parse_line(<<",", rest::binary>>, acc), do: parse_line(rest, acc)

  def parse_line(line, acc) do
    [_, number, rest] = Regex.run(~r{^(\d+),?(.*)$}, line)
    parse_line(rest, [String.to_integer(number) | acc])
  end

  @spec snailnumber_to_string([:down | :up | integer], list) :: binary
  def snailnumber_to_string(number, acc \\ [])

  def snailnumber_to_string([], acc), do: Enum.join(Enum.reverse(acc))

  def snailnumber_to_string([:down, n | rest], acc) when is_integer(n),
    do: snailnumber_to_string(rest, ["[#{n}," | acc])

  def snailnumber_to_string([:up, :down | rest], acc),
    do: snailnumber_to_string([:down | rest], ["]," | acc])

  def snailnumber_to_string([n | rest], acc) when is_integer(n),
    do: snailnumber_to_string(rest, ["#{n}" | acc])

  def snailnumber_to_string([:down | rest], acc), do: snailnumber_to_string(rest, ["[" | acc])

  def snailnumber_to_string([:up, n | rest], acc) when is_integer(n),
    do: snailnumber_to_string(rest, ["],#{n}" | acc])

  def snailnumber_to_string([:up | rest], acc), do: snailnumber_to_string(rest, ["]" | acc])

  def add(m, n), do: [:down] ++ m ++ n ++ [:up]

  def inspect_snail(sn) do
    IO.inspect(snailnumber_to_string(sn))
    sn
  end

  def sum([first]), do: first

  def sum([first, second | snail_numbers]) do
    sum([reduce(add(first, second)) | snail_numbers])
  end

  # [:down, 4, :down, 17, 5, :up, :up]
  def magnitude(n, acc \\ [])
  def magnitude([n], []) when is_integer(n), do: n

  def magnitude([], acc), do: magnitude(Enum.reverse(acc))

  def magnitude([:down, m, n, :up | rest], acc) when is_integer(m) and is_integer(n) do
    magnitude(rest, [3 * m + 2 * n | acc])
  end

  def magnitude([bracket, m | [bracket | _] = rest], acc)
      when is_integer(m) and bracket in [:up, :down],
      do: magnitude(rest, [m, bracket | acc])

  def magnitude([el | rest], acc), do: magnitude(rest, [el | acc])

  def reduce(n) do
    case try_exploding(n) do
      false ->
        case try_splitting(n) do
          false -> n
          new_n when is_list(new_n) -> reduce(new_n)
        end

      new_n when is_list(new_n) ->
        reduce(new_n)
    end
  end

  def try_exploding(n, depth \\ 0, acc \\ [])
  def try_exploding([], _, _), do: false

  def try_exploding([:down, m, n, :up | rest], depth, acc)
      when is_integer(m) and is_integer(n) and depth == 4 do
    # split up m and n
    # end with an array
    # m goes into acc, and n goes into rest
    Enum.reverse(add_to_first_regular_number(acc, m)) ++
      [0] ++ add_to_first_regular_number(rest, n)
  end

  def try_exploding([:down | rest], depth, acc), do: try_exploding(rest, depth + 1, [:down | acc])
  def try_exploding([:up | rest], depth, acc), do: try_exploding(rest, depth - 1, [:up | acc])
  def try_exploding([n | rest], depth, acc), do: try_exploding(rest, depth, [n | acc])

  def add_to_first_regular_number(list, n, acc \\ [])
  def add_to_first_regular_number([], _, acc), do: Enum.reverse(acc)

  def add_to_first_regular_number([a | rest], n, acc) when is_integer(a) do
    Enum.reverse(acc) ++ [a + n | rest]
  end

  # def add_to_first_regular_number([:down, a, b, :up | rest], n, acc)
  #     when is_integer(a) and is_integer(b) do
  #   add_to_first_regular_number(rest, n, [:up, b, a, :down | acc])
  # end

  # def add_to_first_regular_number([m, bracket | rest], n, acc)
  #     when is_integer(m) and bracket in [:up, :down] do
  #   Enum.reverse(acc) ++ [m + n, bracket | rest]
  # end

  # def add_to_first_regular_number([bracket, m, bracket | rest], n, acc)
  #     when is_integer(m) and is_integer(n) and bracket in [:up, :down] do
  #   Enum.reverse(acc) ++ [bracket, m + n, bracket | rest]
  # end

  def add_to_first_regular_number([el | rest], n, acc),
    do: add_to_first_regular_number(rest, n, [el | acc])

  def try_splitting(n, acc \\ [])

  def try_splitting([], _), do: false

  def try_splitting([n | rest], acc)
      when is_integer(n) and n >= 10 do
    left = div(n, 2)
    Enum.reverse(acc) ++ [:down, left, n - left, :up | rest]
  end

  def try_splitting([el | rest], acc), do: try_splitting(rest, [el | acc])
end
