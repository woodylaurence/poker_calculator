defmodule CardTest do
  use ExUnit.Case

  alias PokerCalculator.Models.Card

  test "ranks contain all possible ranks, ordered" do
    assert Card.ranks() == [:ace, :king, :queen, :jack, :ten, :nine, :eight, :seven, :six, :five, :four, :three, :two]
  end

  test "suits contain all possible suits" do
    assert Enum.sort(Card.suits) == Enum.sort([:spades, :hearts, :diamonds, :clubs])
  end

  test "can create a card" do
    card = Card.new(:seven, :diamonds)

    assert card.rank == :seven
    assert card.suit == :diamonds
  end

  test "cannot create a card with a non-existent rank" do
    assert_raise FunctionClauseError, fn ->
      Card.new(:eleven, :hearts)
    end
  end
end
