defmodule AdventOfCode.Day10 do
  def part1(args) do
    args
    |> parse_input()
    |> score_syntax_errors()
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> discard_invalid_lines()
    |> score_completions()
    |> median()
  end

  def parse_input(source) do
    source
    |> String.trim()
    |> String.split(~r{\s*\n\s*}, trim: true)
  end

  def median(scores) do
    number_of_scores = Enum.count(scores)

    scores
    |> Enum.sort()
    |> Enum.at(div(number_of_scores, 2))
  end

  def discard_invalid_lines(lines) do
    Enum.filter(lines, fn line -> is_nil(first_syntax_error(line)) end)
  end

  def score_completions(lines) do
    Enum.map(lines, &score_completion/1)
  end

  def score_syntax_errors(lines) when is_list(lines) do
    Enum.map(lines, &score_syntax_errors/1)
  end

  def score_syntax_errors(line) when is_binary(line) do
    case first_syntax_error(line) do
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
      nil -> 0
    end
  end

  @spec first_syntax_error(binary, [binary]) :: binary | nil
  def first_syntax_error(line, stack \\ [])
  def first_syntax_error(<<>>, _), do: nil

  def first_syntax_error(<<"(", rest::binary>>, stack),
    do: first_syntax_error(rest, [")" | stack])

  def first_syntax_error(<<"[", rest::binary>>, stack),
    do: first_syntax_error(rest, ["]" | stack])

  def first_syntax_error(<<"{", rest::binary>>, stack),
    do: first_syntax_error(rest, ["}" | stack])

  def first_syntax_error(<<"<", rest::binary>>, stack),
    do: first_syntax_error(rest, [">" | stack])

  def first_syntax_error(<<closer::binary-1, rest::binary>>, [closer | stack]),
    do: first_syntax_error(rest, stack)

  def first_syntax_error(<<closer::binary-1, _::binary>>, _), do: closer

  def score_completion(line, stack \\ [])

  def score_completion(<<>>, stack) do
    stack
    |> Enum.map(fn
      ")" -> "1"
      "]" -> "2"
      "}" -> "3"
      ">" -> "4"
    end)
    |> Enum.join("")
    |> String.to_integer(5)
  end

  def score_completion(<<"(", rest::binary>>, stack),
    do: score_completion(rest, [")" | stack])

  def score_completion(<<"[", rest::binary>>, stack),
    do: score_completion(rest, ["]" | stack])

  def score_completion(<<"{", rest::binary>>, stack),
    do: score_completion(rest, ["}" | stack])

  def score_completion(<<"<", rest::binary>>, stack),
    do: score_completion(rest, [">" | stack])

  def score_completion(<<closer::binary-1, rest::binary>>, [closer | stack]),
    do: score_completion(rest, stack)
end
