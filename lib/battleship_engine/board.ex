defmodule BattleshipEngine.Board do
  defstruct ships: [], size: 10

  # TODO: Tests
  def add_ship(board, ship) do
    case can_add_ship?(board, ship) do
      {:ok, ship} ->
        {:ok, %{board | ships: List.insert_at(board.ships, 0, ship)}}
      {:error, message} ->
        {:error, message}
    end
  end

  # TODO: Tests and refactor
  def human(board) do
    pd = "  "

    human_board =
      Enum.reduce(0..board.size, "", fn(y, acc) ->
        line = Enum.reduce(1..board.size, "", fn(x, acc) ->
          any =
            Enum.any?(board.ships, fn(ship) ->
              BattleshipEngine.Ship.in_position(ship, %{x: x, y: <<(?A+y)::utf8>>})
            end)

          ship_or_water = if any, do: "X", else: "0"

          "#{acc}#{ship_or_water}#{pd}"
        end)

        acc =
          if y == 0 do
            acc <> "\n\t1#{pd}2#{pd}3#{pd}4#{pd}5#{pd}6#{pd}7#{pd}8#{pd}9#{pd}10\n\n\n"
          else
            acc
          end

        acc <> "#{<<(?A+y)::utf8>>}\t" <> "#{line}\n"
      end)

    human_board
  end

  def can_add_ship?(board, ship) do
    with {:ok, ship} <- ship_can_be_added?(board, ship),
         {:ok, ship} <- ship_fits?(board, ship),
         {:ok, ship} <- ship_dont_overlap?(board, ship) do
      {:ok, ship}
    else
      {:error, message} -> {:error, message}
    end
  end

  def ship_can_be_added?(board, ship) do
    already_added =
      board.ships |> Enum.any?(fn(existing) -> existing.type == ship.type end)

    if already_added do
      {:error, "ship already in the board"}
    else
      {:ok, ship}
    end
  end

  def ship_fits?(board, ship) do
    placement_position = Enum.at(ship.lives, 0)
    ship_size = Enum.count(ship.lives)

    numeric_X = placement_position[:x]
    # letter integer codepoint
    <<int_codepoint::utf8>> = placement_position[:y]
    numeric_Y = int_codepoint - ?A + 1

    cond do
      ship_size > board.size ->
        {:error, "ship to big for this board"}
      numeric_X <= 0 || numeric_X > board.size ->
        {:error, "can't fit ship, min X is 1 and max is #{board.size}"}
      numeric_Y <= 0 || numeric_Y > board.size ->
        {:error, "can't fit ship, min Y is A and max is #{<<?A + board.size - 1::utf8>>}"}
      ship.orientation == :horizontal && ship_size + numeric_X - 1 > board.size ->
        {:error, "can't fit ship"}
      ship.orientation == :vertical && ship_size + numeric_Y - 1 > board.size ->
        {:error, "can't fit ship"}
      true ->
        {:ok, ship}
    end
  end

  def ship_dont_overlap?(board, ship) do
    overlapping = _ship_dont_overlap?(board.ships, ship, %{})

    case overlapping |> Map.keys |> Enum.count do
      0 -> {:ok, ship}
      _ -> {:error, "ship is overlapping"}
    end
  end

  def _ship_dont_overlap?([], _, acc), do: acc
  def _ship_dont_overlap?([head | tail], ship, acc) do
    {result, overlapping_positions} =
      BattleshipEngine.Ship.overlapping?(head, ship)

    acc = \
      case result do
        :ok -> put_in(acc, [head.type], overlapping_positions)
        :error -> acc
      end

    _ship_dont_overlap?(tail, ship, acc)
  end
end
