defmodule AdventOfCode.Day16 do
  @type packet :: {integer, integer, any}

  @spec part1(binary) :: non_neg_integer()
  def part1(args) do
    args
    |> parse_input()
    |> decode()
    |> count_versions()
  end

  def part2(args) do
    args
    |> parse_input()
    |> decode()
    |> List.first()
    |> interpret_packet()
  end

  def parse_input(source) do
    source
    |> String.trim()
    |> :binary.decode_hex()
  end

  # C0015000016115A2E0802F182340
  # 110 000 0 000000001010100
  #   000 000 0 000000000010110
  #     000 100 0 1010
  #     110 100 0 1011
  #     100 000 1 00000000010
  #       111 100 0 1100
  #       000 100 0 1101
  #     000 000
  # [{6, 0,
  #   [{0, 0,
  #     [{0, 4, 10},
  #      {6, 4, 11},
  #      {4, 0,
  #        [{7, 4, 12},
  #         {0, 4, 13}]}]}]}]
  def decode(binary, count \\ :infinity, acc \\ [])

  def decode("", :infinity, acc), do: Enum.reverse(acc)

  def decode(<<v::size(3), t::size(3), rest::bitstring>>, :infinity, acc) do
    if rest != <<>> do
      {packet, remainder} = decode_packet(v, t, rest)
      decode(remainder, :infinity, [packet | acc])
    else
      Enum.reverse(acc)
    end
  end

  def decode(_, :infinity, acc), do: Enum.reverse(acc)

  def decode("", _, acc), do: {"", Enum.reverse(acc)}
  def decode(source, 0, acc), do: {source, Enum.reverse(acc)}

  def decode(<<v::size(3), t::size(3), rest::bitstring>>, count, acc) do
    {packet, remainder} = decode_packet(v, t, rest)
    decode(remainder, count - 1, [packet | acc])
  end

  @spec decode_packet(integer, integer, bitstring, any) :: {packet, bitstring()}
  def decode_packet(v, t, signal, value \\ nil)

  def decode_packet(v, 4, <<1::size(1), bits::size(4), rest::bitstring>>, value) do
    if is_nil(value),
      do: decode_packet(v, 4, rest, bits),
      else: decode_packet(v, 4, rest, value * 16 + bits)
  end

  def decode_packet(v, 4, <<0::size(1), bits::size(4), rest::bitstring>>, value) do
    if is_nil(value), do: {{v, 4, bits}, rest}, else: {{v, 4, value * 16 + bits}, rest}
  end

  def decode_packet(
        v,
        t,
        <<0::size(1), length::size(15), subcontent::bitstring-size(length), rest::bitstring>>,
        _
      ) do
    subpackets = decode(subcontent)
    {{v, t, subpackets}, rest}
  end

  def decode_packet(v, t, <<1::size(1), count::size(11), rest::bitstring>>, _) do
    {remainder, subpackets} = decode(rest, count)
    {{v, t, subpackets}, remainder}
  end

  def decode_packet(0, 0, _, _), do: {{0, 0, []}, ""}

  @spec count_versions([packet], non_neg_integer()) :: non_neg_integer()
  def count_versions(packets, acc \\ 0)

  def count_versions([], acc), do: acc
  def count_versions([{v, 4, _} | rest], acc), do: count_versions(rest, acc + v)

  def count_versions([{v, _, subpackets} | rest], acc),
    do: count_versions(subpackets ++ rest, acc + v)

  def interpret_packet({_, 0, subpackets}) do
    subpackets
    |> Enum.map(&interpret_packet/1)
    |> Enum.sum()
  end

  def interpret_packet({_, 1, subpackets}) do
    subpackets
    |> Enum.map(&interpret_packet/1)
    |> Enum.product()
  end

  def interpret_packet({_, 2, subpackets}) do
    subpackets
    |> Enum.map(&interpret_packet/1)
    |> Enum.min()
  end

  def interpret_packet({_, 3, subpackets}) do
    subpackets
    |> Enum.map(&interpret_packet/1)
    |> Enum.max()
  end

  def interpret_packet({_, 4, value}), do: value

  def interpret_packet({_, 5, [first, second | _]}) do
    if interpret_packet(first) > interpret_packet(second), do: 1, else: 0
  end

  def interpret_packet({_, 6, [first, second | _]}) do
    if interpret_packet(first) < interpret_packet(second), do: 1, else: 0
  end

  def interpret_packet({_, 7, [first, second | _]}) do
    if interpret_packet(first) == interpret_packet(second), do: 1, else: 0
  end
end
