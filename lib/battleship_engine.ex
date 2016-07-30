defmodule BattleshipEngine do
  def play(board, position) do
    with {ship, index}   <- find_ship(board, position),
         {:hit, ship} <- hit_or_miss(ship, position) do
      board = %{board | ships: List.replace_at(board.ships, index, ship)}

      {:hit, board, ship}
    else
      _ -> {:miss, board, nil}
    end
  end

  defp find_ship(board, position) do
    index =
      board.ships |> Enum.find_index(&BattleshipEngine.Ship.in_position(&1, position))

    case index do
      nil -> {nil, 9001}
      _ -> {Enum.at(board.ships, index), index}
    end
  end

  defp hit_or_miss(ship, position) do
    case ship do
      nil ->
        {:miss}
      _  ->
        {:ok, ship} = BattleshipEngine.Ship.hit(ship, position)
        {:hit, ship}
    end
  end
end
