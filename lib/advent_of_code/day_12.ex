defmodule AdventOfCode.Day12 do
  @type vertex :: binary
  @type graph :: %{vertex => [vertex]}
  @type edge :: {vertex, vertex}
  @type path :: {[vertex], MapSet.t(vertex)} | {[vertex], MapSet.t(vertex), nil | vertex}

  @spec part1(binary) :: non_neg_integer
  def part1(args) do
    graph = parse_input(args)
    count_paths([start_path(:strict)], graph)
  end

  def part2(args) do
    graph = parse_input(args)
    count_paths([start_path(:relaxed)], graph)
  end

  @spec start_path(:strict | :relaxed) :: path
  def start_path(:strict), do: {["start"], MapSet.new(["start"])}

  def start_path(:relaxed), do: {["start"], MapSet.new(["start"]), nil}

  @spec parse_input(binary) :: graph
  def parse_input(source) do
    source
    |> String.trim()
    |> String.split(~r{\s*\n\s*}, trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{}, fn edge, graph -> add_edge(graph, edge) end)
  end

  @spec parse_line(binary) :: edge
  def parse_line(line) do
    line
    |> String.trim()
    |> String.split("-", trim: true, parts: 2)
    |> List.to_tuple()
  end

  @spec add_edge(graph, edge) :: graph
  def add_edge(graph, {v1, v2}) do
    graph
    |> Map.update(v1, [v2], fn list -> [v2 | list] end)
    |> Map.update(v2, [v1], fn list -> [v1 | list] end)
  end

  @spec next_vertices(graph, vertex, MapSet.t(vertex)) :: [vertex]
  def next_vertices(graph, vertex, visited) do
    graph
    |> Map.get(vertex)
    |> Enum.reject(&vertex_seen?(visited, &1))
  end

  @spec vertex_seen(MapSet.t(vertex), vertex) :: MapSet.t(vertex)
  def vertex_seen(visited, vertex) do
    if vertex == String.upcase(vertex), do: visited, else: MapSet.put(visited, vertex)
  end

  @spec vertex_seen?(MapSet.t(vertex), vertex) :: boolean
  def vertex_seen?(visited, vertex), do: MapSet.member?(visited, vertex)

  # given a vertex (and a path that got us there), what are the next steps we want to take?
  # each path has a corresponding set of vertices not to be revisited
  # each path: [v, v , ..., start] with the first element being the most recently visited vertex
  @spec expand_path(graph, path) :: [path]
  def expand_path(graph, {[vertex | _] = path, visited}) do
    graph
    |> next_vertices(vertex, visited)
    |> Enum.map(fn next_vertex ->
      {[next_vertex | path], vertex_seen(visited, next_vertex)}
    end)
  end

  def expand_path(graph, {[vertex | _] = path, visited, nil}) do
    graph
    |> next_vertices(vertex, visited)
    |> Enum.flat_map(fn next_vertex ->
      [
        {[next_vertex | path], vertex_seen(visited, next_vertex), nil},
        {[next_vertex | path], visited, next_vertex}
      ]
    end)
  end

  def expand_path(graph, {[vertex | _] = path, visited, wertex}) do
    graph
    |> next_vertices(vertex, visited)
    |> Enum.flat_map(fn next_vertex ->
      [{[next_vertex | path], vertex_seen(visited, next_vertex), wertex}]
    end)
  end

  @spec count_paths([path], graph, non_neg_integer()) :: non_neg_integer()
  def count_paths(paths, graph, count \\ 0)
  def count_paths([], _, count), do: count

  def count_paths(paths, graph, count) do
    finished_paths =
      Enum.count(paths, fn
        {[v | _], _} -> v == "end"
        {[v | _], _, nil} -> v == "end"
        {[v | _], visited, w} -> v == "end" and vertex_seen?(visited, w)
      end)

    paths
    |> Enum.reject(fn
      {[v | _], _} -> v == "end"
      {[v | _], _, _} -> v == "end"
    end)
    |> Enum.flat_map(&expand_path(graph, &1))
    |> count_paths(graph, count + finished_paths)
  end
end
