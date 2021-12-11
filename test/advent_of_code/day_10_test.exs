defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  test "part1" do
    input = """
      [({(<(())[]>[[{[]{<()<>>
      [(()[<>])]({[<{<<[]>>(
      {([(<{}[<>[]}>{[]{[(<()>
      (((({<>}<{<{<>}{[]{[]{}
      [[<[([]))<([[{}[[()]]]
      [{[{({}]{}}([{[{{{}}([]
      {<[[]]>}<{[{[{[]{()[[[]
      [<(<(<(<{}))><([]([]()
      <{([([[(<>()){}]>(<<{{
      <{([{{}}[<[[[<>{}]]]>[]]
    """

    result = part1(input)

    assert result == 26397
  end

  test "part1 - pattern 1" do
    line = "{([(<{}[<>[]}>{[]{[(<()>"
    result = first_syntax_error(line)
    assert result == "}"
  end

  test "part1 - pattern 2" do
    line = "[[<[([]))<([[{}[[()]]]"
    result = first_syntax_error(line)
    assert result == ")"
  end

  test "part1 - pattern 3" do
    line = "[{[{({}]{}}([{[{{{}}([]"
    result = first_syntax_error(line)
    assert result == "]"
  end

  test "part1 - pattern 4" do
    line = "[<(<(<(<{}))><([]([]()"
    result = first_syntax_error(line)
    assert result == ")"
  end

  test "part1 - pattern 5" do
    line = "<{([([[(<>()){}]>(<<{{"
    result = first_syntax_error(line)
    assert result == ">"
  end

  test "part2" do
    input = """
      [({(<(())[]>[[{[]{<()<>>
      [(()[<>])]({[<{<<[]>>(
      {([(<{}[<>[]}>{[]{[(<()>
      (((({<>}<{<{<>}{[]{[]{}
      [[<[([]))<([[{}[[()]]]
      [{[{({}]{}}([{[{{{}}([]
      {<[[]]>}<{[{[{[]{()[[[]
      [<(<(<(<{}))><([]([]()
      <{([([[(<>()){}]>(<<{{
      <{([{{}}[<[[[<>{}]]]>[]]
    """

    result = part2(input)

    assert result == 288_957
  end

  test "part2 - pattern 1" do
    line = "[({(<(())[]>[[{[]{<()<>>"
    result = score_completion(line)
    assert result == 288_957
  end

  test "part2 - pattern 2" do
    line = "[(()[<>])]({[<{<<[]>>("
    result = score_completion(line)
    assert result == 5566
  end

  test "part2 - pattern 3" do
    line = "(((({<>}<{<{<>}{[]{[]{}"
    result = score_completion(line)
    assert result == 1_480_781
  end

  test "part2 - pattern 4" do
    line = "{<[[]]>}<{[{[{[]{()[[[]"
    result = score_completion(line)
    assert result == 995_444
  end

  test "part2 - pattern 5" do
    line = "<{([{{}}[<[[[<>{}]]]>[]]"
    result = score_completion(line)
    assert result == 294
  end
end
