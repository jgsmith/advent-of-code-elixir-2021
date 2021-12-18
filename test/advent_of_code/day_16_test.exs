defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  test "part1" do
    result = part1("8A004A801A8002F478")
    assert result == 16

    result = part1("620080001611562C8802118E34")
    assert result == 12

    result = part1("C0015000016115A2E0802F182340")
    assert result == 23

    result = part1("A0016C880162017C3686B18A3D4780")
    assert result == 31
  end

  test "part2" do
    assert part2("C200B40A82") == 3
    assert part2("04005AC33890") == 54
    assert part2("880086C3E88112") == 7
    assert part2("CE00C43D881120") == 9
    assert part2("D8005AC2A8F0") == 1
    assert part2("F600BC2D8F") == 0
    assert part2("9C005AC2F8F0") == 0
    assert part2("9C0141080250320F1802104A08") == 1
  end
end
