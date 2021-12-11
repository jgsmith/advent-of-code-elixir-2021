defmodule AdventOfCode.Day04 do
  @type board :: [integer]
  @type boards :: [board]
  @type draws :: [integer]

  @spec part1(binary) :: integer
  def part1(args) do
    {draws, boards} = parse_input(args)

    {winning_board, [last_draw | _] = drawn} = find_winning_board(boards, draws)
    score_board(winning_board, drawn) * last_draw
  end

  def part2(args) do
    {draws, boards} = parse_input(args)
    {last_winning_board, [last_draw | _] = drawn} = find_last_winning_board(boards, draws)

    score_board(last_winning_board, drawn) * last_draw
  end

  @spec parse_input(binary) :: {draws, boards}
  def parse_input(input) do
    # first line contains the bingo numbers
    # the rest are the boards separated by blank lines
    [call_numbers | boards] = String.split(input, ~r{\s*\n\s*\n\s*}, trim: true)
    {parse_call_numbers(call_numbers), parse_boards(boards)}
  end

  @spec parse_call_numbers(binary) :: draws
  def parse_call_numbers(text) do
    text
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @spec parse_boards([binary]) :: boards
  def parse_boards(text) do
    Enum.map(text, &parse_board/1)
  end

  @spec parse_board(binary) :: board
  def parse_board(text) do
    text
    |> String.split(~r{\s+}, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @spec board_winner?(board, draws) :: boolean
  def board_winner?(board, draws) do
    draws
    |> Enum.map(fn draw ->
      Enum.find_index(board, fn spot -> spot == draw end)
    end)
    |> Enum.reject(&is_nil/1)
    |> found_winner?()
  end

  @winners [
    [0, 1, 2, 3, 4],
    [5, 6, 7, 8, 9],
    [10, 11, 12, 13, 14],
    [15, 16, 17, 18, 19],
    [20, 21, 22, 23, 24],
    [0, 5, 10, 15, 20],
    [1, 6, 11, 16, 21],
    [2, 7, 12, 17, 22],
    [3, 8, 12, 18, 23],
    [4, 9, 13, 19, 24]
  ]

  @spec found_winner?([integer]) :: boolean
  def found_winner?(positions) do
    Enum.any?(@winners, fn needed ->
      Enum.all?(needed, &(&1 in positions))
    end)
  end

  @spec score_board([integer], [integer]) :: integer
  def score_board(board, draws) do
    board
    |> Enum.reject(&(&1 in draws))
    |> Enum.sum()
  end

  @spec find_winning_board([[integer]], [integer], [integer]) ::
          nil | {[integer], [integer]}
  def find_winning_board(boards, draws, drawn \\ [])
  def find_winning_board(_, [], _), do: nil

  def find_winning_board(boards, [draw | draws], drawn) do
    case Enum.find(boards, &board_winner?(&1, [draw | drawn])) do
      nil -> find_winning_board(boards, draws, [draw | drawn])
      board when is_list(board) -> {board, [draw | drawn]}
    end
  end

  @spec find_last_winning_board(boards, draws) :: {board, draws} | nil
  def find_last_winning_board([board], draws) do
    find_winning_board([board], draws)
  end

  def find_last_winning_board(boards, draws) do
    {winner, [last_draw | _] = drawn} = find_winning_board(boards, draws)
    IO.inspect({:eliminating, winner, score_board(winner, drawn) * last_draw})

    boards
    |> Enum.reject(fn board -> board == winner end)
    |> find_last_winning_board(draws)
  end
end
