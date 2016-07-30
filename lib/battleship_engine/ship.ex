defmodule BattleshipEngine.Ship do
  defstruct type: :no_ship,
            name: "No Ship",
            lives: [],
            destroyed: false,
            orientation: :horizontal

  # Write tests for this
  def get(name, position, orientation) do
    orientation = String.to_atom(orientation)

    case name do
      "submarine" -> BattleshipEngine.Ship.submarine(position, orientation)
      "destroyer" -> BattleshipEngine.Ship.destroyer(position, orientation)
      "cruiser" -> BattleshipEngine.Ship.cruiser(position, orientation)
      "battleship" -> BattleshipEngine.Ship.battleship(position, orientation)
      "aircraft_carrier" -> BattleshipEngine.Ship.aircraft_carrier(position, orientation)
    end
  end

  def submarine(position, orientation) do
    with {:ok, lives} <- build_lives(position, 1, orientation) do
      %BattleshipEngine.Ship{
        type: :submarine,
        name: "Submarine",
        lives: lives,
        orientation: orientation
      }
    end
  end

  def destroyer(position, orientation) do
    with {:ok, lives} <- build_lives(position, 2, orientation) do
      %BattleshipEngine.Ship{
        type: :destroyer,
        name: "Destroyer",
        lives: lives,
        orientation: orientation
      }
    end
  end

  def cruiser(position, orientation) do
    with {:ok, lives} <- build_lives(position, 3, orientation) do
      %BattleshipEngine.Ship{
        type: :cruiser,
        name: "Cruiser",
        lives: lives,
        orientation: orientation
      }
    end
  end

  def battleship(position, orientation) do
    with {:ok, lives} <- build_lives(position, 4, orientation) do
      %BattleshipEngine.Ship{
        type: :battleship,
        name: "Battleship",
        lives: lives,
        orientation: orientation
      }
    end
  end

  def aircraft_carrier(position, orientation) do
    with {:ok, lives} <- build_lives(position, 5, orientation) do
      %BattleshipEngine.Ship{
        type: :aircraft_carrier,
        name: "Aircraft Carrier",
        lives: lives,
        orientation: orientation
       }
    end
  end

  def hit(ship, position) do
    {:ok, (ship |> try_hit_ship(position) |> destroy_ship_if_no_lives)}
  end

  def build_lives(position, size, orientation) do
    position_y_codepoint = String.to_char_list(position[:y]) |> List.first

    case orientation do
      :vertical ->
        {:ok, (Enum.reduce(position_y_codepoint..position_y_codepoint+size-1, [], fn(y, acc) ->
          List.insert_at(acc, -1, build_live(position[:x], <<y::utf8>>))
        end))}
      :horizontal ->
        {:ok,(Enum.reduce(position[:x]..position[:x]+size-1, [], fn(x, acc) ->
          List.insert_at(acc, -1, build_live(x, position[:y]))
        end))}
      _ ->
        {:error, "invalid orientation"}
    end
  end

  def in_position(ship, position) do
    ship.lives |> Enum.find(fn(ship_position) ->
      ship_position[:x] == position[:x] && ship_position[:y] == position[:y]
    end)
  end

  defp try_hit_ship(ship, position) do
    # TODO: refactor
    lives = \
      ship.lives
      |> Enum.map(fn(live)->
        if live[:x] == position[:x] && live[:y] == position[:y] do
          %{live | hit: true}
        else
          live
        end
      end)

    %{ship | lives: lives}
  end

  defp destroy_ship_if_no_lives(ship) do
    %{ship | destroyed: ship.lives |> Enum.all?(fn(live) -> live[:hit] == true end)}
  end

  defp build_live(x, y) do
    %{x: x, y: y, hit: false}
  end

  def overlapping?(ship_a, ship_b) do
    overlaps = find_overlaps(ship_a.lives, ship_b.lives, [])

    case Enum.count(overlaps) do
      0 -> {:error, []}
      _ -> {:ok, overlaps}
    end
  end

  defp find_overlaps(_, [], acc), do: acc
  defp find_overlaps(lives, [head|tail], acc) do
    overlap = Enum.find(lives, fn(live) ->
      live[:x] == head[:x] && live[:y] == head[:y]
    end)

    acc = \
      case overlap do
        nil -> acc
        _ -> [%{x: overlap[:x], y: overlap[:y]}|acc]
      end

    find_overlaps(lives, tail, acc)
  end
end
