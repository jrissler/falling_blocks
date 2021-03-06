defmodule FallingBlocks.BlockTest do
  use ExUnit.Case

  alias FallingBlocks.{Block, Board}

  describe "down" do
    test "it moves a block down" do
      o = Block.o({1, 2})
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))

      o = Block.down(o)

      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {1, 4}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 4}))
    end
  end

  describe "left" do
    test "it moves a block left" do
      o = Block.o({1, 2})
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))

      o = Block.left(o)

      assert o.parts |> Enum.find(&(&1 == {0, 2}))
      assert o.parts |> Enum.find(&(&1 == {0, 3}))
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
    end
  end

  describe "right" do
    test "it moves a block right" do
      o = Block.o({1, 2})
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))

      o = Block.right(o)

      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))
      assert o.parts |> Enum.find(&(&1 == {3, 2}))
      assert o.parts |> Enum.find(&(&1 == {3, 3}))
    end
  end

  describe "up" do
    test "it moves a block up" do
      o = Block.o({1, 2})
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))

      o = Block.up(o)

      assert o.parts |> Enum.find(&(&1 == {1, 1}))
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 1}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
    end
  end

  describe "o" do
    test "it puts an o" do
      o = Block.o({1, 2})
      assert o.type == :o
      assert o.parts |> Enum.count() == 4
      assert o.parts |> Enum.find(&(&1 == {1, 2}))
      assert o.parts |> Enum.find(&(&1 == {1, 3}))
      assert o.parts |> Enum.find(&(&1 == {2, 2}))
      assert o.parts |> Enum.find(&(&1 == {2, 3}))
    end
  end

  describe "i" do
    test "it puts the block horizontally" do
      i = Block.i({2, 1})
      assert i.type == :i
      assert i.parts |> Enum.count() == 4
      assert i.parts |> Enum.find(&(&1 == {2, 1}))
      assert i.parts |> Enum.find(&(&1 == {3, 1}))
      assert i.parts |> Enum.find(&(&1 == {4, 1}))
      assert i.parts |> Enum.find(&(&1 == {5, 1}))
    end
  end

  describe "t" do
    test "it puts the block vertically" do
      t = Block.t({2, 1})
      assert t.type == :t
      assert t.parts |> Enum.count() == 4
      assert t.parts |> Enum.find(&(&1 == {3, 1}))
      assert t.parts |> Enum.find(&(&1 == {2, 2}))
      assert t.parts |> Enum.find(&(&1 == {3, 2}))
      assert t.parts |> Enum.find(&(&1 == {4, 2}))
    end
  end

  describe "width" do
    test "it counts the width" do
      assert Block.width(:i) == 4
      assert Block.width(:o) == 2
      assert Block.width(:s) == 3
      assert Block.width(:z) == 3
      assert Block.width(:j) == 3
      assert Block.width(:l) == 3
      assert Block.width(:t) == 3
    end
  end

  describe "height" do
    test "it counts the height" do
      assert Block.height(:i) == 1
      assert Block.height(:o) == 2
      assert Block.height(:s) == 2
      assert Block.height(:z) == 2
      assert Block.height(:j) == 2
      assert Block.height(:l) == 2
      assert Block.height(:t) == 2
    end
  end

  describe "remove_row" do
    test "returns nil if block would no longer have any parts" do
      i = Block.i({2, 1})
      assert Block.remove_row(i, 1) == nil
    end

    test "removes parts of the block that lie on the given row and moves down the ones above it" do
      o = Block.o({1, 2})
      o2 = Block.remove_row(o, 3)
      assert o2.parts |> Enum.count() == 2
      assert o2.parts |> Enum.find(&(&1 == {1, 3}))
      assert o2.parts |> Enum.find(&(&1 == {2, 3}))
    end
  end

  describe "rows" do
    test "it returns a list of all rows occupied by this block, sorted" do
      i = Block.i({2, 1})
      o = Block.o({1, 2})
      non_standard_block = %Block{type: :unknown, parts: [{2, 4}, {2, 3}, {1, 4}]}

      assert Block.rows(i) == [1]
      assert Block.rows(o) == [2, 3]
      assert Block.rows(non_standard_block) == [3, 4]
    end
  end

  describe "rotate" do
    test "O" do
      board = %Board{height: 5, width: 5, static_blocks: [], falling_block: nil}

      o = Block.o({1, 1})
      assert o.rotation == 0

      assert inspect(%{board | falling_block: o}) == ~s"""
             . . . . .
             . o o . .
             . o o . .
             . . . . .
             . . . . .
             """

      o2 = Block.rotate(o)
      assert o2.rotation == 0

      assert inspect(%{board | falling_block: o2}) == ~s"""
             . . . . .
             . o o . .
             . o o . .
             . . . . .
             . . . . .
             """
    end

    test "I" do
      board = %Board{height: 5, width: 5, static_blocks: [], falling_block: nil}

      i = Block.i({1, 1})
      assert i.rotation == 0

      assert inspect(%{board | falling_block: i}) == ~s"""
             . . . . .
             . i i i i
             . . . . .
             . . . . .
             . . . . .
             """

      i2 = Block.rotate(i)
      assert i2.rotation == 1

      assert inspect(%{board | falling_block: i2}) == ~s"""
             . . . i .
             . . . i .
             . . . i .
             . . . i .
             . . . . .
             """

      i3 = Block.rotate(i2)
      assert i3.rotation == 2

      assert inspect(%{board | falling_block: i3}) == ~s"""
             . . . . .
             . . . . .
             . i i i i
             . . . . .
             . . . . .
             """

      i4 = Block.rotate(i3)
      assert i4.rotation == 3

      assert inspect(%{board | falling_block: i4}) == ~s"""
             . . i . .
             . . i . .
             . . i . .
             . . i . .
             . . . . .
             """

      i5 = Block.rotate(i4)
      assert i5.rotation == 0

      assert inspect(%{board | falling_block: i5}) == ~s"""
             . . . . .
             . i i i i
             . . . . .
             . . . . .
             . . . . .
             """
    end

    test "T" do
      board = %Board{height: 5, width: 5, static_blocks: [], falling_block: nil}

      t = Block.t({1, 1})
      assert t.rotation == 0

      assert inspect(%{board | falling_block: t}) == ~s"""
             . . . . .
             . . t . .
             . t t t .
             . . . . .
             . . . . .
             """

      t2 = Block.rotate(t)
      assert t2.rotation == 1

      assert inspect(%{board | falling_block: t2}) == ~s"""
             . . . . .
             . . t . .
             . . t t .
             . . t . .
             . . . . .
             """

      t3 = Block.rotate(t2)
      assert t3.rotation == 2

      assert inspect(%{board | falling_block: t3}) == ~s"""
             . . . . .
             . . . . .
             . t t t .
             . . t . .
             . . . . .
             """

      t4 = Block.rotate(t3)
      assert t4.rotation == 3

      assert inspect(%{board | falling_block: t4}) == ~s"""
             . . . . .
             . . t . .
             . t t . .
             . . t . .
             . . . . .
             """

      t5 = Block.rotate(t4)
      assert t5.rotation == 0

      assert inspect(%{board | falling_block: t5}) == ~s"""
             . . . . .
             . . t . .
             . t t t .
             . . . . .
             . . . . .
             """
    end

    test "S" do
      board = %Board{height: 5, width: 5, static_blocks: [], falling_block: nil}

      s = Block.s({1, 1})
      assert s.rotation == 0

      assert inspect(%{board | falling_block: s}) == ~s"""
             . . . . .
             . . s s .
             . s s . .
             . . . . .
             . . . . .
             """

      s2 = Block.rotate(s)
      assert s2.rotation == 1

      assert inspect(%{board | falling_block: s2}) == ~s"""
             . . . . .
             . . s . .
             . . s s .
             . . . s .
             . . . . .
             """

      s3 = Block.rotate(s2)
      assert s3.rotation == 2

      assert inspect(%{board | falling_block: s3}) == ~s"""
             . . . . .
             . . . . .
             . . s s .
             . s s . .
             . . . . .
             """

      s4 = Block.rotate(s3)
      assert s4.rotation == 3

      assert inspect(%{board | falling_block: s4}) == ~s"""
             . . . . .
             . s . . .
             . s s . .
             . . s . .
             . . . . .
             """

      s5 = Block.rotate(s4)
      assert s5.rotation == 0

      assert inspect(%{board | falling_block: s5}) == ~s"""
             . . . . .
             . . s s .
             . s s . .
             . . . . .
             . . . . .
             """
    end

    test "Z" do
      board = %Board{height: 5, width: 5, static_blocks: [], falling_block: nil}

      z = Block.z({1, 1})
      assert z.rotation == 0

      assert inspect(%{board | falling_block: z}) == ~s"""
             . . . . .
             . z z . .
             . . z z .
             . . . . .
             . . . . .
             """

      z2 = Block.rotate(z)
      assert z2.rotation == 1

      assert inspect(%{board | falling_block: z2}) == ~s"""
             . . . . .
             . . . z .
             . . z z .
             . . z . .
             . . . . .
             """

      z3 = Block.rotate(z2)
      assert z3.rotation == 2

      assert inspect(%{board | falling_block: z3}) == ~s"""
             . . . . .
             . . . . .
             . z z . .
             . . z z .
             . . . . .
             """

      z4 = Block.rotate(z3)
      assert z4.rotation == 3

      assert inspect(%{board | falling_block: z4}) == ~s"""
             . . . . .
             . . z . .
             . z z . .
             . z . . .
             . . . . .
             """

      z5 = Block.rotate(z4)
      assert z5.rotation == 0

      assert inspect(%{board | falling_block: z5}) == ~s"""
             . . . . .
             . z z . .
             . . z z .
             . . . . .
             . . . . .
             """
    end

    test "J" do
      board = %Board{height: 5, width: 5, static_blocks: [], falling_block: nil}

      j = Block.j({1, 1})
      assert j.rotation == 0

      assert inspect(%{board | falling_block: j}) == ~s"""
             . . . . .
             . j . . .
             . j j j .
             . . . . .
             . . . . .
             """

      j2 = Block.rotate(j)
      assert j2.rotation == 1

      assert inspect(%{board | falling_block: j2}) == ~s"""
             . . . . .
             . . j j .
             . . j . .
             . . j . .
             . . . . .
             """

      j3 = Block.rotate(j2)
      assert j3.rotation == 2

      assert inspect(%{board | falling_block: j3}) == ~s"""
             . . . . .
             . . . . .
             . j j j .
             . . . j .
             . . . . .
             """

      j4 = Block.rotate(j3)
      assert j4.rotation == 3

      assert inspect(%{board | falling_block: j4}) == ~s"""
             . . . . .
             . . j . .
             . . j . .
             . j j . .
             . . . . .
             """

      j5 = Block.rotate(j4)
      assert j5.rotation == 0

      assert inspect(%{board | falling_block: j5}) == ~s"""
             . . . . .
             . j . . .
             . j j j .
             . . . . .
             . . . . .
             """
    end

    test "L" do
      board = %Board{height: 5, width: 5, static_blocks: [], falling_block: nil}

      l = Block.l({1, 1})
      assert l.rotation == 0

      assert inspect(%{board | falling_block: l}) == ~s"""
             . . . . .
             . . . l .
             . l l l .
             . . . . .
             . . . . .
             """

      l2 = Block.rotate(l)
      assert l2.rotation == 1

      assert inspect(%{board | falling_block: l2}) == ~s"""
             . . . . .
             . . l . .
             . . l . .
             . . l l .
             . . . . .
             """

      l3 = Block.rotate(l2)
      assert l3.rotation == 2

      assert inspect(%{board | falling_block: l3}) == ~s"""
             . . . . .
             . . . . .
             . l l l .
             . l . . .
             . . . . .
             """

      l4 = Block.rotate(l3)
      assert l4.rotation == 3

      assert inspect(%{board | falling_block: l4}) == ~s"""
             . . . . .
             . l l . .
             . . l . .
             . . l . .
             . . . . .
             """

      l5 = Block.rotate(l4)
      assert l5.rotation == 0

      assert inspect(%{board | falling_block: l5}) == ~s"""
             . . . . .
             . . . l .
             . l l l .
             . . . . .
             . . . . .
             """
    end
  end
end
