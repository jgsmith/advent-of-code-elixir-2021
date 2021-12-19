defmodule AdventOfCode.Day15 do
  def part1(args) do
    {map, _} =
      args
      |> parse_input()
      |> find_minimal_path()

    Map.get(map, Enum.max(Map.keys(map)))
  end

  def part2(args) do
    {risks, _} =
      args
      |> parse_input()
      |> explode_map()
      |> find_minimal_path()
      |> write_ppm_to_file("risks-2.ppm")

    Map.get(risks, Enum.max(Map.keys(risks)))
  end

  @spec parse_input(binary) :: %{{integer, integer} => integer}
  def parse_input(source) do
    source
    |> String.trim()
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {r, x} -> {{x, y}, r} end)
    end)
    |> Enum.into(%{})
  end

  def explode_map(map) do
    {max_x, max_y} = Enum.max(Map.keys(map))
    width = max_x + 1
    height = max_y + 1
    extent = {width, height}

    Enum.reduce(0..4, map, fn x, acc ->
      Enum.reduce(0..4, acc, fn y, acc ->
        add_copy(acc, map, x, y, extent)
      end)
    end)
  end

  def add_copy(map, _, 0, 0, _), do: map

  def add_copy(map, original, right, down, {width, height}) do
    increment = right + down

    original
    |> Enum.reduce(map, fn {{x, y}, r}, acc ->
      Map.put(acc, {x + right * width, y + down * height}, rem(r + increment - 1, 9) + 1)
    end)
  end

  @spec find_minimal_path(map) :: {map, map}
  def find_minimal_path(map) do
    find_minimal_path(map, PriorityQueue.put(PriorityQueue.new(), {{0, 0}, 0}), %{{0, 0} => 0})
  end

  @spec find_minimal_path(map, PriorityQueue.t(), map, map) :: {map, map}
  def find_minimal_path(map, q, risks, prevs \\ %{}) do
    if PriorityQueue.empty?(q) do
      {risks, prevs}
    else
      {{point, queued_risk}, q} = PriorityQueue.pop!(q)
      point_risk = Map.get(risks, point)

      if queued_risk != point_risk do
        find_minimal_path(map, q, risks, prevs)
      else
        {new_q, new_risks, new_prevs} =
          point
          |> next_points()
          |> Enum.filter(fn p -> Map.has_key?(map, p) end)
          |> Enum.reduce({q, risks, prevs}, fn p, {q, risks, prevs} ->
            alt = point_risk + Map.get(map, p)

            if alt < Map.get(risks, p, :infinite) do
              {PriorityQueue.put(q, {p, alt}), Map.put(risks, p, alt), Map.put(prevs, p, point)}
            else
              {q, risks, prevs}
            end
          end)

        find_minimal_path(map, new_q, new_risks, new_prevs)
      end
    end
  end

  def next_points({x, y}), do: [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]

  def write_ppm_to_file(map, file) do
    File.write!(file, map_to_ppm(map))
    map
  end

  def find_path(_, [{0, 0} | _] = path), do: path

  def find_path(prevs, [point | _] = path) do
    find_path(prevs, [Map.get(prevs, point) | path])
  end

  @spec map_to_ppm(
          {%{{integer, integer} => integer}, %{{integer, integer} => {integer, integer}}}
        ) :: iodata
  def map_to_ppm({map, prevs}) do
    {max_x, max_y} = Enum.max(Map.keys(map))
    max_r = Enum.max(Map.values(map))
    white = "#{max_r} #{max_r} #{max_r}   "
    path = find_path(prevs, [{max_x, max_y}])

    [
      "P3\n",
      Integer.to_string(max_x + 1),
      " ",
      Integer.to_string(max_y + 1),
      "\n",
      Integer.to_string(max_r),
      "\n",
      Enum.map(0..max_y, fn y ->
        [
          Enum.map(0..max_x, fn x ->
            if {x, y} in path do
              white
            else
              risk = Map.get(map, {x, y})

              [
                Integer.to_string(risk),
                " ",
                Integer.to_string(div(3 * risk, 4)),
                " ",
                Integer.to_string(max_r - risk),
                "   "
              ]
            end
          end),
          "\n"
        ]
      end)
    ]
  end
end
