defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1 - example 1" do
    input = """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

    result = part1(input)

    assert result == 10
  end

  test "part1 - example 2" do
    input = """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """

    result = part1(input)

    assert result == 19
  end

  test "part1 - example 3" do
    input = """
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """

    result = part1(input)

    assert result == 226
  end

  test "part2 - example 1" do
    input = """
    start-A
    start-b
    A-c
    A-b
    b-d
    A-end
    b-end
    """

    result = part2(input)

    assert result == 36
  end

  test "part2 - example 2" do
    input = """
    dc-end
    HN-start
    start-kj
    dc-start
    dc-HN
    LN-dc
    HN-end
    kj-sa
    kj-HN
    kj-dc
    """

    result = part2(input)

    assert result == 103
  end

  test "part2 - example 3" do
    input = """
    fs-end
    he-DX
    fs-he
    start-DX
    pj-DX
    end-zg
    zg-sl
    zg-pj
    pj-he
    RW-he
    fs-DX
    pj-RW
    zg-RW
    start-pj
    he-WI
    zg-he
    pj-fs
    start-RW
    """

    result = part2(input)

    assert result == 3509
  end
end
