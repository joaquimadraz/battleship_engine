# BattleshipEngine

I've been learning Elixir in the past months and been applying some of the learnings in this project.

It's a basic engine for the Battleship game.

## API

### Basic Usage
Given a specific board:

```elixir
board = %BattleshipEngine.Board{size: 10}

battleship = BattleshipEngine.Ship.battleship(%{x: 1, y: "A"}, :horizontal)

{:ok, board} = %BattleshipEngine.Board.add_ship(battleship)

{result, board, ship} = BattleshipEngine.play(board, %{x: 2, y: "A"})

IO.inspect result
# => :hit

{result, board} = BattleshipEngine.play(board, %{x: 6, y: "A"})

IO.inspect result
# => :miss
```

### Ships

At the moment only one ship from each class is allowed on a board.


| Class  | Size |
| --- | --- |
| aircraft_carrier | 5 |
| battleship | 4 |
| cruiser | 3 |
| destroyer | 2 |
| submarine | 1 |


#### Create a ship

Execute:

```elixir
ship = BattleshipEngine.Ship.battleship(%{x: 2, y: "A"}, :horizontal)
```
Result:

```elixir
IO.inspect ship
# => %BattleshipEngine.Ship{
#      destroyed: false,
#      lives: [
#   	 %{hit: false, x: 2, y: "A"},
#   	 %{hit: false, x: 3, y: "A"},
#   	 %{hit: false, x: 4, y: "A"},
#   	 %{hit: false, x: 5, y: "A"}
#      ],
#      name: "Battleship",
#      orientation: :horizontal,
#      type: :battleship
#    }

```

#### Check if ships overlap
Execute:

```elixir
aircraft_carrier = BattleshipEngine.Ship.aircraft_carrier(%{x: 1, y: "C"}, :horizontal)

cruiser = BattleshipEngine.Ship.cruiser(%{x: 3, y: "B"}, :vertical)

result = BattleshipEngine.Ship.overlapping?(aircraft_carrier, cruiser)
```

Result:

```elixir
IO.inspect result
# => {:ok, [%{x: 3, y: "C"}]}

```
| |1|2|3|4|5|
|---|---|---|---|---|---|
|A| | | | | |
|B| | |x| | |
|C|x|x|x|x|x|
|D| | |x| | |
|E| | | | | |


### Board

The default board size is 10x10:

#### Add ships to the board
Execute:

```elixir
aircraft_carrier = BattleshipEngine.Ship.aircraft_carrier(%{x: 2, y: "C"}, :vertical)

{:ok, board} = %BattleshipEngine.Board.add_ship(aircraft_carrier)
```

Result:

```elixir
IO.inspect board
# => %BattleshipEngine.Board{
# 	 ships: [
# 	   %BattleshipEngine.Ship{
# 	     destroyed: false,
# 	     lives: [
# 	       %{hit: false, x: 2, y: "C"},
# 	       %{hit: false, x: 2, y: "D"},
# 	       %{hit: false, x: 2, y: "E"},
# 	       %{hit: false, x: 2, y: "F"},
# 	       %{hit: false, x: 2, y: "G"}],
# 	     name: "Aircraft Carrier",
# 	     orientation: :vertical,
# 	     type: :aircraft_carrier
# 	   }
# 	 ],
# 	 size: 10
#      }
#    }
```

#### Print an "human version" of the board

```elixir
aircraft_carrier = BattleshipEngine.Ship.aircraft_carrier(%{x: 2, y: "C"}, :vertical)
cruiser = BattleshipEngine.Ship.cruiser(%{x: 4, y: "B"}, :horizontal)

{:ok, board} = %BattleshipEngine.Board.add_ship(aircraft_carrier)
{:ok, board} = %BattleshipEngine.Board.add_ship(cruiser)

IO.puts BattleshipEngine.Board.human(board)
```

|   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A |   |   |   |   |   |   |   |   |   |   |
| B |   |   |   | x | x | x |   |   |   |   |
| C |   | x |   |   |   |   |   |   |   |   |
| D |   | x |   |   |   |   |   |   |   |   |
| E |   | x |   |   |   |   |   |   |   |   |
| F |   | x |   |   |   |   |   |   |   |   |
| G |   | x |   |   |   |   |   |   |   |   |
| H |   |   |   |   |   |   |   |   |   |   |
| I |   |   |   |   |   |   |   |   |   |   |
| J |   |   |   |   |   |   |   |   |   |   |


## Test

```
mix test
```

## TODO
Still a work in progress!

- [ ] game rules, multiple ships of the same clas
- [ ] human board identifing ships
- [ ] human board with hits and misses
- [ ] publish on hex.pm
