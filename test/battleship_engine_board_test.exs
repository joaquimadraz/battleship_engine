defmodule BattleshipEngineBoardTest do
  use ExUnit.Case
  doctest BattleshipEngine.Board

  describe "#can_add_ship?" do
    test "should return error for existing ship already" do
      board = %BattleshipEngine.Board{ships: [
        BattleshipEngine.Ship.submarine(%{x: 2, y: "A"}, :horizontal)
      ]}

      submarine = BattleshipEngine.Ship.submarine(%{x: 2, y: "A"}, :horizontal)

      result = BattleshipEngine.Board.can_add_ship?(board, submarine)

      assert result == {:error, "ship already in the board"}
    end

    test "should return error for a ship that can't fit" do
      board = %BattleshipEngine.Board{ships: [
        BattleshipEngine.Ship.submarine(%{x: 2, y: "A"}, :horizontal)
      ]}

      aircraft = BattleshipEngine.Ship.aircraft_carrier(%{x: 1, y: "G"}, :vertical)

      result = BattleshipEngine.Board.can_add_ship?(board, aircraft)

      assert result == {:error, "can't fit ship"}
    end

    test "should add the ship" do
      board = %BattleshipEngine.Board{ships: [
        BattleshipEngine.Ship.submarine(%{x: 2, y: "A"}, :horizontal)
      ]}

      destroyer = BattleshipEngine.Ship.destroyer(%{x: 1, y: "J"}, :horizontal)

      {status, ship} = BattleshipEngine.Board.can_add_ship?(board, destroyer)

      assert status == :ok
      assert ship.type == :destroyer
    end
  end

  describe "#ship_can_be_added?" do
    test "should return error for ship already added to board" do
      board = %BattleshipEngine.Board{ships: [
          BattleshipEngine.Ship.submarine(%{x: 2, y: "A"}, :horizontal)
      ]}

      submarine = BattleshipEngine.Ship.submarine(%{x: 2, y: "A"}, :horizontal)

      {:error, message} = BattleshipEngine.Board.ship_can_be_added?(board, submarine)

      assert message == "ship already in the board"
    end
  end

  describe "#ship_fits?" do
    test "should return :ok for submarine" do
      board = %BattleshipEngine.Board{size: 3}

      submarine =
        BattleshipEngine.Ship.submarine(%{x: 1, y: "A"}, :horizontal)

      {:ok, ship} = BattleshipEngine.Board.ship_fits?(board, submarine)

      assert ship.type == :submarine
    end

    test "should return :error for ship to big" do
      board = %BattleshipEngine.Board{size: 3}

      aircraft =
        BattleshipEngine.Ship.aircraft_carrier(%{x: 2, y: "A"}, :horizontal)

      {:error, message} = BattleshipEngine.Board.ship_fits?(board, aircraft)

      assert message == "ship to big for this board"
    end

    test "should return :error for vertical position out of bound" do
      board = %BattleshipEngine.Board{size: 10}

      aircraft =
        BattleshipEngine.Ship.aircraft_carrier(%{x: 1, y: "G"}, :vertical)

      {:error, message} = BattleshipEngine.Board.ship_fits?(board, aircraft)

      assert message == "can't fit ship"
    end

    test "should return :error for horizontal position out of bound" do
      board = %BattleshipEngine.Board{size: 10}

      aircraft =
        BattleshipEngine.Ship.aircraft_carrier(%{x: 7, y: "A"}, :horizontal)

      {:error, message} = BattleshipEngine.Board.ship_fits?(board, aircraft)

      assert message == "can't fit ship"
    end

    test "should return :error for invalid min X position" do
      board = %BattleshipEngine.Board{size: 10}

      submarine =
        BattleshipEngine.Ship.submarine(%{x: 0, y: "A"}, :horizontal)

      {status, message} = BattleshipEngine.Board.ship_fits?(board, submarine)

      assert status == :error
      assert message == "can't fit ship, min X is 1 and max is 10"
    end

    test "should return :error for invalid max X position" do
      board = %BattleshipEngine.Board{size: 10}

      submarine =
        BattleshipEngine.Ship.submarine(%{x: 11, y: "A"}, :horizontal)

      {status, message} = BattleshipEngine.Board.ship_fits?(board, submarine)

      assert status == :error
      assert message == "can't fit ship, min X is 1 and max is 10"
    end

    test "should return :error for invalid max Y position" do
      board = %BattleshipEngine.Board{size: 10}

      submarine =
        BattleshipEngine.Ship.submarine(%{x: 10, y: "K"}, :horizontal)

      {status, message} = BattleshipEngine.Board.ship_fits?(board, submarine)

      assert status == :error
      assert message == "can't fit ship, min Y is A and max is #{<<?A + board.size - 1::utf8>>}"
    end

    test "should return :ok when adding ship on min X position" do
      board = %BattleshipEngine.Board{size: 10}

      submarine =
        BattleshipEngine.Ship.submarine(%{x: 1, y: "A"}, :horizontal)

      {status, _} = BattleshipEngine.Board.ship_fits?(board, submarine)

      assert status == :ok
    end

    test "should return :ok when adding ship on max X position" do
      board = %BattleshipEngine.Board{size: 10}

      submarine =
        BattleshipEngine.Ship.submarine(%{x: 10, y: "A"}, :horizontal)

      {status, _} = BattleshipEngine.Board.ship_fits?(board, submarine)

      assert status == :ok
    end

    test "should return :ok when adding ship on max Y position" do
      board = %BattleshipEngine.Board{size: 10}

      submarine =
        BattleshipEngine.Ship.submarine(%{x: 10, y: "J"}, :horizontal)

      {status, _} = BattleshipEngine.Board.ship_fits?(board, submarine)

      assert status == :ok
    end
  end

  describe "#ship_dont_overlap?" do
    test "should return :error for overlaping ship" do
      board = %BattleshipEngine.Board{ships: [
          BattleshipEngine.Ship.submarine(%{x: 2, y: "A"}, :horizontal)
      ]}

      aircraft_carrier = BattleshipEngine.Ship.aircraft_carrier(%{x: 2, y: "A"}, :horizontal)

      {:error, message} = BattleshipEngine.Board.ship_dont_overlap?(board, aircraft_carrier)

      assert message == "ship is overlapping"
    end
  end
end
