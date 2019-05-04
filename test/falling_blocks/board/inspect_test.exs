defmodule FallingBlocks.Board.InspectTest do
  use ExUnit.Case

  alias FallingBlocks.Board
  alias FallingBlocks.Block

  describe "inspect" do
    test "empty board" do
      empty = %Board{height: 6, width: 3}

      assert inspect(empty) == ~s"""
             . . .
             . . .
             . . .
             . . .
             . . .
             . . .
             """
    end

    test "a T" do
      block = Block.t({0, 1})
      board = %Board{height: 3, width: 3, static_blocks: [block]}

      assert inspect(board) == ~s"""
             . . .
             . x .
             x x x
             """
    end

    test "two static Os" do
      blocks = [
        Block.o({0, 4}),
        Block.o({1, 2})
      ]

      board = %Board{height: 6, width: 3, static_blocks: blocks}

      assert inspect(board) == ~s"""
             . . .
             . . .
             . * *
             . * *
             * * .
             * * .
             """
    end

    test "an O and two Is" do
      blocks = [
        Block.i({0, 4}),
        Block.o({1, 5}),
        Block.i({0, 7})
      ]

      board = %Board{height: 8, width: 4, static_blocks: blocks}

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             . . . .
             . . . .
             o o o o
             . * * .
             . * * .
             o o o o
             """
    end

    test "a falling I" do
      i = Block.i({0, 2})
      board = %Board{height: 8, width: 4, static_blocks: [], falling_block: i}

      assert inspect(board) == ~s"""
             . . . .
             . . . .
             o o o o
             . . . .
             . . . .
             . . . .
             . . . .
             . . . .
             """
    end
  end
end
