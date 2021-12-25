defmodule AdventOfCode.Day18Test do
  use ExUnit.Case

  import AdventOfCode.Day18

  test "part1" do
    input = """
    [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
    [[[5,[2,8]],4],[5,[[9,9],0]]]
    [6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
    [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
    [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
    [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
    [[[[5,4],[7,7]],8],[[8,3],8]]
    [[9,3],[[9,9],[6,[4,9]]]]
    [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
    [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
    """

    result = part1(input)

    assert result == 4140
  end

  test "sum" do
    assert snailnumber_to_string(
             sum([
               parse_line("[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]"),
               parse_line("[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]")
             ])
           ) == "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]"

    assert snailnumber_to_string(
             sum([parse_line("[[[[4,3],4],4],[7,[[8,4],9]]]"), parse_line("[1,1]")])
           ) == "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]"
  end

  test "magnitude" do
    assert magnitude(parse_line("[17,5]")) == 17 * 3 + 5 * 2
    assert magnitude(parse_line("[4,[17,5]]")) == 4 * 3 + (17 * 3 + 5 * 2) * 2
    assert magnitude(parse_line("[[1,2],[[3,4],5]]")) == 143
  end

  test "try_exploding" do
    assert try_exploding(parse_line("[[[[[9,8],1],2],3],4]")) == parse_line("[[[[0,9],2],3],4]")
    assert try_exploding(parse_line("[7,[6,[5,[4,[3,2]]]]]")) == parse_line("[7,[6,[5,[7,0]]]]")
    assert try_exploding(parse_line("[[6,[5,[4,[3,2]]]],1]")) == parse_line("[[6,[5,[7,0]]],3]")

    assert try_exploding(parse_line("[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]")) ==
             parse_line("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")

    assert try_exploding(parse_line("[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]")) ==
             parse_line("[[3,[2,[8,0]]],[9,[5,[7,0]]]]")

    assert snailnumber_to_string(
             try_exploding(parse_line("[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]"))
           ) == "[[[[0,7],4],[7,[[8,4],9]]],[1,1]]"

    assert snailnumber_to_string(try_exploding(parse_line("[[[[0,7],4],[7,[[8,4],9]]],[1,1]]"))) ==
             "[[[[0,7],4],[15,[0,13]]],[1,1]]"

    assert snailnumber_to_string(
             try_exploding(parse_line("[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]"))
           ) ==
             "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"
  end

  test "try_splitting" do
    assert try_splitting(parse_line("[[[[0,7],4],[15,[0,13]]],[1,1]]")) ==
             parse_line("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")

    assert try_splitting(parse_line("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]")) ==
             parse_line("[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]")

    assert snailnumber_to_string(try_splitting(parse_line("[[[[0,7],4],[15,[0,13]]],[1,1]]"))) ==
             "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]"

    assert snailnumber_to_string(try_splitting(parse_line("[[[[0,7],4],[[7,8],[0,13]]],[1,1]]"))) ==
             "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]"
  end

  test "reduce" do
    assert snailnumber_to_string(
             reduce(sum([parse_line("[[[[4,3],4],[7,[[8,4],9]]]"), parse_line("[1,1]")]))
           ) == "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
