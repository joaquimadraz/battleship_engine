defmodule BattleshipEngineTest do
  use ExUnit.Case
  doctest BattleshipEngine

  describe "#play" do
    setup do
      [board:
        %BattleshipEngine.Board{
          ships: [
            BattleshipEngine.Ship.submarine(%{x: 2, y: "A"}, :horizontal),
            BattleshipEngine.Ship.destroyer(%{x: 1, y: "J"}, :horizontal)
          ]
        }
      ]
    end

    test "should hit once and destroy a submarine", context do
      {hit_miss, _, ship} = BattleshipEngine.play(context.board, %{x: 2, y: "A"})

      assert hit_miss == :hit
      assert ship.type == :submarine
      assert ship.destroyed == true
      assert Enum.at(ship.lives, 0)[:hit] == true
    end

    test "should miss the submarine", context do
      {hit_miss, _, _} = BattleshipEngine.play(context.board, %{x: 3, y: "A"})

      assert hit_miss == :miss
    end

    test "should hit once and not destroy a destroyer", context do
      {hit_miss, _, ship} = BattleshipEngine.play(context.board, %{x: 1, y: "J"})

      assert hit_miss == :hit
      assert ship.type == :destroyer
      assert ship.destroyed == false
      assert Enum.at(ship.lives, 0)[:hit] == true
      assert Enum.at(ship.lives, 1)[:hit] == false
    end

    test "should hit twice and destroy a destroyer", context do
      {hit_miss, board, ship} = BattleshipEngine.play(context.board, %{x: 1, y: "J"})

      assert hit_miss == :hit
      assert Enum.at(ship.lives, 0)[:hit] == true
      assert ship.type == :destroyer
      assert ship.destroyed == false

      {hit_miss, board, ship} = BattleshipEngine.play(board, %{x: 2, y: "J"})

      assert hit_miss == :hit
      assert Enum.at(ship.lives, 1)[:hit] == true
      assert ship.type == :destroyer
      assert ship.destroyed == true

      # the same ship on board is destroyed
      assert \
        Enum.all?(Enum.at(board.ships, 1).lives, fn(live) -> live[:hit] == true end) == true
    end
  end
end
