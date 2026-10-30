defmodule HandRankCalculatorTest do
  use ExUnit.Case

  alias PokerCalculator.Models.Card
  alias PokerCalculator.Models.Hand
  alias PokerCalculator.HandRank
  alias PokerCalculator.HandRankCalculator

  describe "royal flush" do
    test "royal flush should return royal flush with empty kickers" do
      #   ROYAL FLUSH    -   OTHERS
      # {AS KS QS JS 10S} - {4H} - {7H}
      {:ok, hand} =
        Hand.new([
          Card.new(:ace, :spades),
          Card.new(:jack, :spades),
          Card.new(:seven, :hearts),
          Card.new(:ten, :spades),
          Card.new(:queen, :spades),
          Card.new(:king, :spades),
          Card.new(:four, :hearts)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :royal_flush, kickers: []}
    end
  end

  describe "straight flush" do
    test "straight flush should return straight flush with kicker set to highest straight value" do
      # STRAIGHT FLUSH   -   OTHERS
      # {8H 7H 6H 5H 4H} - {10S} - {2C}
      {:ok, hand} =
        Hand.new([
          Card.new(:four, :hearts),
          Card.new(:six, :hearts),
          Card.new(:seven, :hearts),
          Card.new(:eight, :hearts),
          Card.new(:ten, :spades),
          Card.new(:five, :hearts),
          Card.new(:two, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :straight_flush, kickers: [:eight]}
    end

    test "straight flush with higher extra card of same suit should return straight flush with kicker set to highest straight value" do
      # STRAIGHT FLUSH    -   OTHERS
      # {JH 10H 9H 8H 7H} - {AH} - {4H}
      {:ok, hand} =
        Hand.new([
          Card.new(:ten, :hearts),
          Card.new(:seven, :hearts),
          Card.new(:ace, :hearts),
          Card.new(:nine, :hearts),
          Card.new(:jack, :hearts),
          Card.new(:eight, :hearts),
          Card.new(:four, :hearts)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :straight_flush, kickers: [:jack]}
    end

    test "straight flush with higher extra card of different suit should return straight flush with kicker set to highest straight flush value" do
      # STRAIGHT FLUSH    -   OTHERS
      # {JH 10H 9H 8H 7H} - {QC} - {2D}
      {:ok, hand} =
        Hand.new([
          Card.new(:ten, :hearts),
          Card.new(:seven, :hearts),
          Card.new(:queen, :clubs),
          Card.new(:nine, :hearts),
          Card.new(:jack, :hearts),
          Card.new(:eight, :hearts),
          Card.new(:two, :diamonds)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :straight_flush, kickers: [:jack]}
    end
  end

  describe "four of a kind" do
    test "four of a kind should return four of a kind with kickers set to four of a kind value then highest remaining card value" do
      #  FOUR OF A KIND   -   OTHERS
      # {10C 10D 10H 10S} - {9D 6H 3S}
      {:ok, hand} =
        Hand.new([
          Card.new(:nine, :diamonds),
          Card.new(:ten, :hearts),
          Card.new(:ten, :spades),
          Card.new(:three, :spades),
          Card.new(:ten, :diamonds),
          Card.new(:ten, :clubs),
          Card.new(:six, :hearts)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :four_of_a_kind, kickers: [:ten, :nine]}
    end

    test "four of a kind and higher three of a kind should return four of a kind with kickers set to four of a kind value then highest remaining card value" do
      #  FOUR OF A KIND   -   OTHERS
      # {10C 10D 10H 10S} - {KC KH KS}
      {:ok, hand} =
        Hand.new([
          Card.new(:king, :hearts),
          Card.new(:ten, :hearts),
          Card.new(:ten, :spades),
          Card.new(:king, :spades),
          Card.new(:ten, :diamonds),
          Card.new(:ten, :clubs),
          Card.new(:king, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :four_of_a_kind, kickers: [:ten, :king]}
    end
  end

  describe "full house" do
    test "full house should return full house with kickers set to three of a kind value then pair value" do
      #     FULL HOUSE    -  OTHERS
      # {7C 7D 7H} {2H 2C} - {9D 4C}
      {:ok, hand} =
        Hand.new([
          Card.new(:seven, :clubs),
          Card.new(:four, :clubs),
          Card.new(:seven, :hearts),
          Card.new(:nine, :diamonds),
          Card.new(:two, :clubs),
          Card.new(:two, :hearts),
          Card.new(:seven, :diamonds)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :full_house, kickers: [:seven, :two]}
    end

    test "one three of a kind and two pairs should return full house with kickers set to three of a kind value then pair value" do
      #       FULL HOUSE      -  OTHERS
      # {8C 8S 8H} {10C 10S} - {4D 4C}
      {:ok, hand} =
        Hand.new([
          Card.new(:eight, :clubs),
          Card.new(:four, :clubs),
          Card.new(:ten, :spades),
          Card.new(:eight, :spades),
          Card.new(:four, :diamonds),
          Card.new(:eight, :hearts),
          Card.new(:ten, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :full_house, kickers: [:eight, :ten]}
    end

    test "two three of a kinds and higher extra card should return full house with kickers set to higher three of a kind then lower three of a kind value" do
      #        FULL HOUSE      -  OTHERS
      # {10D 10C 10S} {8C 8S} - {8H AD}
      {:ok, hand} =
        Hand.new([
          Card.new(:eight, :clubs),
          Card.new(:ace, :diamonds),
          Card.new(:ten, :spades),
          Card.new(:eight, :spades),
          Card.new(:ten, :diamonds),
          Card.new(:eight, :hearts),
          Card.new(:ten, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :full_house, kickers: [:ten, :eight]}
    end

    test "two three of a kinds and lower extra card should return full house with kickers set to higher three of a kind then lower three of a kind value" do
      #        FULL HOUSE      -  OTHERS
      # {10D 10C 10S} {8C 8S} - {8H 5D}
      {:ok, hand} =
        Hand.new([
          Card.new(:eight, :clubs),
          Card.new(:ten, :spades),
          Card.new(:eight, :spades),
          Card.new(:ten, :diamonds),
          Card.new(:eight, :hearts),
          Card.new(:five, :diamonds),
          Card.new(:ten, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :full_house, kickers: [:ten, :eight]}
    end
  end

  describe "flush" do
    test "flush with more than five cards in flush should return flush with kickers set to top five flush values descending" do
      #        FLUSH        -  OTHERS
      # {AD QD 7D 6D 4D 3D} - {9C}
      {:ok, hand} =
        Hand.new([
          Card.new(:ace, :diamonds),
          Card.new(:three, :diamonds),
          Card.new(:six, :diamonds),
          Card.new(:queen, :diamonds),
          Card.new(:four, :diamonds),
          Card.new(:nine, :clubs),
          Card.new(:seven, :diamonds)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :flush, kickers: [:ace, :queen, :seven, :six, :four]}
    end

    test "flush should return flush with kickers set to flush values descending" do
      #      FLUSH       -  OTHERS
      # {KC 9C 7C 3C 2C} - {4S AD}
      {:ok, hand} =
        Hand.new([
          Card.new(:king, :clubs),
          Card.new(:two, :clubs),
          Card.new(:four, :spades),
          Card.new(:seven, :clubs),
          Card.new(:three, :clubs),
          Card.new(:ace, :diamonds),
          Card.new(:nine, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :flush, kickers: [:king, :nine, :seven, :three, :two]}
    end

    test "flush and straight but not straight flush should return flush with kickers set to flush values descending" do
      #       FLUSH       -  OTHERS
      # {10C 9C 7C 6C 2C} - {JS 8D}
      {:ok, hand} =
        Hand.new([
          Card.new(:six, :clubs),
          Card.new(:nine, :clubs),
          Card.new(:eight, :diamonds),
          Card.new(:jack, :spades),
          Card.new(:ten, :clubs),
          Card.new(:two, :clubs),
          Card.new(:seven, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :flush, kickers: [:ten, :nine, :seven, :six, :two]}
    end

    test "flush and three of a kind should return flush with kickers set to flush values descending" do
      #       FLUSH       -  OTHERS
      # {AC 10C 8C 7C 5C} - {10H 10D}
      {:ok, hand} =
        Hand.new([
          Card.new(:seven, :clubs),
          Card.new(:ten, :diamonds),
          Card.new(:ten, :clubs),
          Card.new(:ten, :hearts),
          Card.new(:five, :clubs),
          Card.new(:eight, :clubs),
          Card.new(:ace, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :flush, kickers: [:ace, :ten, :eight, :seven, :five]}
    end
  end

  describe "straight" do
    test "straight should return straight with kicker set to highest straight value" do
      #      STRAIGHT      -  OTHERS
      # {KS QD JH 10C 9C} - {2D 6H}
      {:ok, hand} =
        Hand.new([
          Card.new(:queen, :diamonds),
          Card.new(:two, :diamonds),
          Card.new(:king, :spades),
          Card.new(:nine, :clubs),
          Card.new(:six, :hearts),
          Card.new(:jack, :hearts),
          Card.new(:ten, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :straight, kickers: [:king]}
    end

    test "straight with ace low should return straight with kicker not set to ace" do
      #     STRAIGHT     -  OTHERS
      # {5H 4D 3S 2H AC} - {10D 7H}
      {:ok, hand} =
        Hand.new([
          Card.new(:three, :spades),
          Card.new(:two, :hearts),
          Card.new(:ace, :clubs),
          Card.new(:ten, :diamonds),
          Card.new(:five, :hearts),
          Card.new(:seven, :hearts),
          Card.new(:four, :diamonds)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :straight, kickers: [:five]}
    end

    test "straight of length greater than five should return straight with kicker set to straight high value" do
      #      STRAIGHT      -  OTHERS
      # {10D 9H 8D 7H 6S} - {5H 4C}
      {:ok, hand} =
        Hand.new([
          Card.new(:nine, :hearts),
          Card.new(:eight, :diamonds),
          Card.new(:six, :spades),
          Card.new(:four, :clubs),
          Card.new(:ten, :diamonds),
          Card.new(:seven, :hearts),
          Card.new(:five, :hearts)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :straight, kickers: [:ten]}
    end

    test "straight and three of a kind should return straight with kicker set to straight high value" do
      #     STRAIGHT     -  OTHERS
      # {8D 7H 6D 5H 4C} - {6H 6S}
      {:ok, hand} =
        Hand.new([
          Card.new(:six, :diamonds),
          Card.new(:five, :hearts),
          Card.new(:seven, :hearts),
          Card.new(:six, :hearts),
          Card.new(:four, :clubs),
          Card.new(:six, :spades),
          Card.new(:eight, :diamonds)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :straight, kickers: [:eight]}
    end
  end

  describe "three of a kind" do
    test "three of a kind should return three of a kind with kickers set to triple value then two highest remaining card values" do
      # THREE OF A KIND -     OTHERS
      #   {6H 6S 6C}    - {QC 7D 4H 3S}
      {:ok, hand} =
        Hand.new([
          Card.new(:six, :hearts),
          Card.new(:seven, :diamonds),
          Card.new(:four, :hearts),
          Card.new(:six, :spades),
          Card.new(:queen, :diamonds),
          Card.new(:three, :spades),
          Card.new(:six, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :three_of_a_kind, kickers: [:six, :queen, :seven]}
    end
  end

  describe "two pair" do
    test "multiple pairs and highest value card after two pairs is from another pair should return two pair with kickers set to highest pair, next highest pair, then highest value card from final pair" do
      #     TWO PAIR      -   OTHERS
      # {AH AS} {QC QH} - {6C 6D 3S}
      {:ok, hand} =
        Hand.new([
          Card.new(:six, :clubs),
          Card.new(:queen, :hearts),
          Card.new(:ace, :hearts),
          Card.new(:three, :spades),
          Card.new(:queen, :clubs),
          Card.new(:six, :diamonds),
          Card.new(:ace, :spades)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :two_pair, kickers: [:ace, :queen, :six]}
    end

    test "multiple pairs and highest value card after two pairs is from card not in pair should return two pair with kickers set to highest pair, next highest pair, then next highest card" do
      #     TWO PAIR      -   OTHERS
      # {QC QH} {6C 6D} - {AS 3H 3S}
      {:ok, hand} =
        Hand.new([
          Card.new(:six, :clubs),
          Card.new(:ace, :spades),
          Card.new(:queen, :clubs),
          Card.new(:queen, :hearts),
          Card.new(:three, :hearts),
          Card.new(:six, :diamonds),
          Card.new(:three, :spades)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :two_pair, kickers: [:queen, :six, :ace]}
    end

    test "two pairs should return two pair with kickers set to highest pair, next pair, then highest remaining card" do
      #     TWO PAIR      -   OTHERS
      # {QC QH} {3H 3S} - {AS 8D 6C}
      {:ok, hand} =
        Hand.new([
          Card.new(:three, :spades),
          Card.new(:queen, :clubs),
          Card.new(:three, :hearts),
          Card.new(:six, :clubs),
          Card.new(:queen, :hearts),
          Card.new(:eight, :diamonds),
          Card.new(:ace, :spades)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :two_pair, kickers: [:queen, :three, :ace]}
    end
  end

  describe "pair" do
    test "pair and pair value lower than highest card should return pair with kickers set to pair value then three highest cards descending" do
      #   PAIR   -       OTHERS
      # {6H 6C} - {QC JS 10C 9H 3S}
      {:ok, hand} =
        Hand.new([
          Card.new(:nine, :hearts),
          Card.new(:six, :clubs),
          Card.new(:jack, :spades),
          Card.new(:six, :hearts),
          Card.new(:three, :spades),
          Card.new(:ten, :clubs),
          Card.new(:queen, :clubs)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :pair, kickers: [:six, :queen, :jack, :ten]}
    end
  end

  describe "high card" do
    test "high card should return high card with kickers set to values descending" do
      # HIGH CARD -        OTHERS
      #   {QC}    - {JS 10C 9H 7C 6H 3S}
      {:ok, hand} =
        Hand.new([
          Card.new(:ten, :clubs),
          Card.new(:three, :spades),
          Card.new(:nine, :hearts),
          Card.new(:queen, :clubs),
          Card.new(:seven, :clubs),
          Card.new(:jack, :spades),
          Card.new(:six, :hearts)
        ])

      assert HandRankCalculator.calculate_hand_rank(hand) ==
               %HandRank{rank: :high_card, kickers: [:queen, :jack, :ten, :nine, :seven]}
    end
  end
end
