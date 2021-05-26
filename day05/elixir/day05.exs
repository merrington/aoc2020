defmodule Day05 do
  def go do
    path = "../sample.txt"

    File.stream!(path)
    |> Enum.map(&build_data/1)
  end

  def build_data(line) do
    data =
      line
      |> String.trim()
      |> String.reverse()
      |> String.graphemes()

    %{
      row: Enum.take(data, 7) |> convert(),
      aisle: Enum.take(data, -3) |> convert()
      # id:,
    }
    |> IO.inspect()
  end

  def convert(chars) do
    chars
    |> Enum.map(fn
      char when char == "B" or char == "R" -> 1
      _char -> 0
    end)
    |> Enum.with_index()
    |> Enum.reduce(0, fn item, acc ->
      {value, pos} = item
      acc + :math.pow(value, pos)
    end)
  end
end

# Part 1
Day05.go()
