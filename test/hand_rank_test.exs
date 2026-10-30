defmodule HandRankTest do
  use ExUnit.Case

  alias PokerCalculator.HandRank

  test "royal flush has no kickers" do
    assert %HandRank{rank: :royal_flush, kickers: []} = HandRank.new(:royal_flush, [])
    assert_raise FunctionClauseError, fn -> HandRank.new(:royal_flush, [:seven]) end
  end

  test "straight flush has single kicker" do
    kicker_1 = :seven
    kicker_2 = :king

    assert_raise FunctionClauseError, fn -> HandRank.new(:straight_flush, []) end
    assert %HandRank{rank: :straight_flush, kickers: [^kicker_1]} = HandRank.new(:straight_flush, [kicker_1])
    assert_raise FunctionClauseError, fn -> HandRank.new(:straight_flush, [kicker_1, kicker_2]) end
  end

  test "four of a kind has two kickers" do
    kicker_1 = :seven
    kicker_2 = :king
    kicker_3 = :two

    assert_raise FunctionClauseError, fn -> HandRank.new(:four_of_a_kind, []) end
    assert_raise FunctionClauseError, fn -> HandRank.new(:four_of_a_kind, [kicker_1]) end
    assert %HandRank{rank: :four_of_a_kind, kickers: [^kicker_1, ^kicker_2]} = HandRank.new(:four_of_a_kind, [kicker_1, kicker_2])
    assert_raise FunctionClauseError, fn -> HandRank.new(:four_of_a_kind, [kicker_1, kicker_2, kicker_3]) end
  end

  test "full house has two kickers" do
    kicker_1 = :seven
    kicker_2 = :king
    kicker_3 = :two

    assert_raise FunctionClauseError, fn -> HandRank.new(:full_house, []) end
    assert_raise FunctionClauseError, fn -> HandRank.new(:full_house, [kicker_1]) end
    assert %HandRank{rank: :full_house, kickers: [^kicker_1, ^kicker_2]} = HandRank.new(:full_house, [kicker_1, kicker_2])
    assert_raise FunctionClauseError, fn -> HandRank.new(:full_house, [kicker_1, kicker_2, kicker_3]) end
  end

  test "flush has five kickers" do
    kicker_1 = :seven
    kicker_2 = :king
    kicker_3 = :two
    kicker_4 = :jack
    kicker_5 = :four
    kicker_6 = :nine

    assert_raise FunctionClauseError, fn -> HandRank.new(:flush, []) end
    assert_raise FunctionClauseError, fn -> HandRank.new(:flush, [kicker_1, kicker_2, kicker_3, kicker_4]) end
    assert %HandRank{rank: :flush, kickers: [^kicker_1, ^kicker_2, ^kicker_3, ^kicker_4, ^kicker_5]} = HandRank.new(:flush, [kicker_1, kicker_2, kicker_3, kicker_4, kicker_5])
    assert_raise FunctionClauseError, fn -> HandRank.new(:flush, [kicker_1, kicker_2, kicker_3, kicker_4, kicker_5, kicker_6]) end
  end

  test "straight has single kicker" do
    kicker_1 = :seven
    kicker_2 = :king

    assert_raise FunctionClauseError, fn -> HandRank.new(:straight, []) end
    assert %HandRank{rank: :straight, kickers: [^kicker_1]} = HandRank.new(:straight, [kicker_1])
    assert_raise FunctionClauseError, fn -> HandRank.new(:straight, [kicker_1, kicker_2]) end
  end

  test "three of a kind has three kickers" do
    kicker_1 = :seven
    kicker_2 = :king
    kicker_3 = :two
    kicker_4 = :jack

    assert_raise FunctionClauseError, fn -> HandRank.new(:three_of_a_kind, []) end
    assert_raise FunctionClauseError, fn -> HandRank.new(:three_of_a_kind, [kicker_1, kicker_2]) end
    assert %HandRank{rank: :three_of_a_kind, kickers: [^kicker_1, ^kicker_2, ^kicker_3]} = HandRank.new(:three_of_a_kind, [kicker_1, kicker_2, kicker_3])
    assert_raise FunctionClauseError, fn -> HandRank.new(:three_of_a_kind, [kicker_1, kicker_2, kicker_3, kicker_4]) end
  end

  test "two pair has three kickers" do
    kicker_1 = :seven
    kicker_2 = :king
    kicker_3 = :two
    kicker_4 = :jack

    assert_raise FunctionClauseError, fn -> HandRank.new(:two_pair, []) end
    assert_raise FunctionClauseError, fn -> HandRank.new(:two_pair, [kicker_1, kicker_2]) end
    assert %HandRank{rank: :two_pair, kickers: [^kicker_1, ^kicker_2, ^kicker_3]} = HandRank.new(:two_pair, [kicker_1, kicker_2, kicker_3])
    assert_raise FunctionClauseError, fn -> HandRank.new(:two_pair, [kicker_1, kicker_2, kicker_3, kicker_4]) end
  end

  test "pair has four kickers" do
    kicker_1 = :seven
    kicker_2 = :king
    kicker_3 = :two
    kicker_4 = :jack
    kicker_5 = :four

    assert_raise FunctionClauseError, fn -> HandRank.new(:pair, []) end
    assert_raise FunctionClauseError, fn -> HandRank.new(:pair, [kicker_1, kicker_2, kicker_3]) end
    assert %HandRank{rank: :pair, kickers: [^kicker_1, ^kicker_2, ^kicker_3, ^kicker_4]} = HandRank.new(:pair, [kicker_1, kicker_2, kicker_3, kicker_4])
    assert_raise FunctionClauseError, fn -> HandRank.new(:pair, [kicker_1, kicker_2, kicker_3, kicker_4, kicker_5]) end
  end

  test "high card has five kickers" do
    kicker_1 = :seven
    kicker_2 = :king
    kicker_3 = :two
    kicker_4 = :jack
    kicker_5 = :four
    kicker_6 = :nine

    assert_raise FunctionClauseError, fn -> HandRank.new(:high_card, []) end
    assert_raise FunctionClauseError, fn -> HandRank.new(:high_card, [kicker_1, kicker_2, kicker_3, kicker_4]) end
    assert %HandRank{rank: :high_card, kickers: [^kicker_1, ^kicker_2, ^kicker_3, ^kicker_4, ^kicker_5]} = HandRank.new(:high_card, [kicker_1, kicker_2, kicker_3, kicker_4, kicker_5])
    assert_raise FunctionClauseError, fn -> HandRank.new(:high_card, [kicker_1, kicker_2, kicker_3, kicker_4, kicker_5, kicker_6]) end
  end

  test "unknown rank cannot be created" do
    assert_raise FunctionClauseError, fn -> HandRank.new(:five_of_a_kind, []) end
  end
end
