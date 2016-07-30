defmodule BattleshipEngineShipTest do
  use ExUnit.Case

  describe "#build" do
    test "should build Submarine" do
      submarine = BattleshipEngine.Ship.submarine(%{x: 2, y: "J"}, :horizontal)

      assert submarine.name == "Submarine"
      assert submarine.type == :submarine
      assert submarine.lives == [%{x: 2, y: "J", hit: false}]
    end
  end

  describe "#build_lives" do
    test "should return error for invalid orientation" do
      result = \
        BattleshipEngine.Ship.build_lives(%{x: 1, y: "A"}, 3, :down)

      assert result == {:error, "invalid orientation"}
    end

    test "should build lives horizontally" do
      {:ok, lives} = \
        BattleshipEngine.Ship.build_lives(%{x: 1, y: "A"}, 3, :horizontal)

      assert lives == [
        %{x: 1, y: "A", hit: false},
        %{x: 2, y: "A", hit: false},
        %{x: 3, y: "A", hit: false}
      ]
    end

    test "should build lives vertically" do
      {:ok, lives} = \
        BattleshipEngine.Ship.build_lives(%{x: 1, y: "A"}, 3, :vertical)

      assert lives == [
        %{x: 1, y: "A", hit: false},
        %{x: 1, y: "B", hit: false},
        %{x: 1, y: "C", hit: false}
      ]
    end
  end

  describe "#overlapping?" do
    test "should return :ok on overlapping" do
      cruiser_1 = BattleshipEngine.Ship.cruiser(%{x: 1, y: "B"}, :horizontal)
      cruiser_2 = BattleshipEngine.Ship.cruiser(%{x: 2, y: "A"}, :vertical)

      {:ok, overlaps} = BattleshipEngine.Ship.overlapping?(cruiser_1, cruiser_2)

      assert List.first(overlaps) == %{x: 2, y: "B"}
    end

    test "should return :error on overlapping" do
      cruiser_1 = BattleshipEngine.Ship.cruiser(%{x: 1, y: "B"}, :horizontal)
      cruiser_2 = BattleshipEngine.Ship.cruiser(%{x: 1, y: "A"}, :horizontal)

      {:error, []} = BattleshipEngine.Ship.overlapping?(cruiser_1, cruiser_2)
    end
  end
end
