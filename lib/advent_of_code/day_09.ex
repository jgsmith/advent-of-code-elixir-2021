defmodule AdventOfCode.Day09 do
  def part1(args) do
    args
    |> parse_input()
    |> calculate_risk()
  end

  def part2(args) do
    map = parse_input(args)

    map
    |> scan_map()
    |> Enum.reject(&is_nil/1)
    |> size_basins(map)
    |> Enum.map(fn {_, s} -> s end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def parse_input(source) do
    source
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse_line/1)
    |> List.to_tuple()
  end

  def parse_line(line) do
    line
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def height_at(map, x, y) when x >= 0 and y >= 0 and y < tuple_size(map) do
    line = elem(map, y)
    if x >= tuple_size(line), do: nil, else: elem(line, x)
  end

  def height_at(_, _, _), do: nil

  def is_low_point?(map, x, y) do
    point_height = height_at(map, x, y)

    x
    |> surrounding_points(y)
    |> Enum.map(fn {xx, yy} -> height_at(map, xx, yy) end)
    |> Enum.reject(&is_nil/1)
    |> Enum.all?(fn h -> h > point_height end)
  end

  def surrounding_points(x, y) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
  end

  def point_on_map?(map, {x, y}) do
    x >= 0 and y >= 0 and y < tuple_size(map) and x < tuple_size(elem(map, 0))
  end

  def scan_map(map) do
    size_y = tuple_size(map)
    size_x = tuple_size(elem(map, 0))

    for y <- 0..(size_y - 1), x <- 0..(size_x - 1) do
      if is_low_point?(map, x, y), do: {x, y}, else: nil
    end
  end

  def calculate_risk(map) do
    map
    |> scan_map()
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn {x, y} -> height_at(map, x, y) + 1 end)
    |> Enum.sum()
  end

  def size_basins(low_points, map) do
    # for each low point, calculate the size of the corresponding basin
    Enum.map(low_points, fn {x, y} -> {{x, y}, size_basin(x, y, map)} end)
  end

  def size_basin(x, y, map) do
    # this is basically A* from the point outwards as long as the next steps are increasing and not equal to 9
    Enum.count(find_basin(map, [{x, y}], []))
  end

  def find_basin(_, [], visited), do: Enum.uniq(visited)

  def find_basin(map, [{x, y} = point | rest], visited) do
    # we want to look at all points that have height greater than ours that haven't been visited yet and aren't in *rest*
    if {x, y} in visited do
      find_basin(map, rest, visited)
    else
      height_at_point = height_at(map, x, y)

      next_points =
        surrounding_points(x, y)
        |> Enum.filter(&point_on_map?(map, &1))
        |> Enum.filter(fn {x, y} ->
          height_at(map, x, y) >= height_at_point and height_at(map, x, y) < 9
        end)

      find_basin(map, rest ++ next_points, [point | visited])
    end
  end
end
