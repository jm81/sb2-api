# Count number of words in a text and optionally determine if it is an exact or
# close match for the given level. An exact match is 2**level words. A close
# match is with 10% of an exact match. Matchers return false if no level is
# specified.
class WordCountChecker
  attr_reader :actual

  # @param text [String] Text to analyze
  # @param level [Integer]
  def initialize text, level = nil
    @text = text.to_s
    @level = level ? level.to_i : nil
    count_words!
  end

  # @return [Integer] Expected word count for level.
  def expected
    self.class.expected_for @level
  end

  # @return [Ranger<Integer>] Close-enough range of word counts for level.
  def range
    self.class.range_for @level
  end

  # @return [Boolean] Is this an exact match to the expected word count?
  def exact?
    @level ? expected == actual : false
  end

  # @return [Boolean] Is this an match to the expected words within the range?
  def match?
    @level ? range === actual : false
  end

  # @return [Symbol] Type of match: :exact, :close, :none
  def type
    if exact?
      :exact
    elsif match?
      :close
    else
      :none
    end
  end

  # Build a hash suitable for building JSON, with the following keys:
  # :actual, :expected, :range, :type.
  #
  # Only :actual is returned if @level is not set.
  #
  # @return [Hash]
  def to_hash
    if @level
      { actual: actual, expected: expected, range: range, type: type }
    else
      { actual: actual }
    end
  end

  private

  # Set @actual from word count for text, using Microsoft Word standard.
  #
  # @return [Integer] Word count.
  def count_words!
    @actual = WordCountAnalyzer::Counter.new(text: @text).mword_count
  end

  class << self
    # @return [Integer] 2 ** level.
    def expected_for level
      2 ** level
    end

    # @return [Range<Integer>] Accepted values for this level.
    def range_for level
      @range_for ||= Hash.new do |hsh, key|
        expected_words = expected_for key
        minimum = (expected_words.to_f * 0.9).ceil
        maximum = (expected_words.to_f * 1.1).floor

        hsh[key] = (minimum..maximum)
      end

      @range_for[level]
    end
  end
end
