defimpl Inspect, for: FallingBlocks.Board do
  @doc """
    Makes a very simple ASCII image of the board.
  """
  def inspect(%FallingBlocks.Board{} = board, _opts) do
    0..(board.height - 1)
    |> Enum.map(fn row ->
      0..(board.width - 1)
      |> Enum.map(fn column ->
        block_symbol(FallingBlocks.Board.block_type_at(board, {column, row}))
      end)
      |> Enum.join(" ")
    end)
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  defp block_symbol(:o), do: "*"
  defp block_symbol(:i), do: "o"
  defp block_symbol(_), do: "."
end
