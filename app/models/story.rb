class Story < Sequel::Model
  include ActiveModel::SerializerSupport

  plugin :validation_helpers

  many_to_one :author, class: :Profile
  many_to_one :parent, class: :Story
  one_to_many :children, class: :Story, key: :parent_id

  attr_writer :direction

  # Set body and words (word count) from value.
  #
  # @param value [String] Body (text) of story.
  def body= value
    self.words = self.class.word_count value
    super
  end

  # If given a direction of '+' or '-', determine the level for a child of this
  # Story as either one greater or one less than this Story's level.
  #
  # @param direction [String] '+' or '-'.
  # @return [Integer, nil] Level for child, or nil if direction is not valid.
  def level_for_child direction
    case direction
    when '+'
      level + 1
    when '-'
      level - 1
    else
      nil
    end
  end

  private

  # If @direction is set, set level in relation to parent.
  def set_level_from_direction
    if parent && @direction
      self.level = parent.level_for_child @direction
    end
  end

  def validate
    set_level_from_direction

    super

    validates_presence [:author, :body]

    if level.blank? || level.to_i < 0
      errors.add(:level, 'must be a positive integer')
    end
  end

  class << self
    # Get word count for text, using Microsoft Word standard.
    #
    # @return [Integer] Word count.
    def word_count text
      WordCountChecker.new(text).actual
    end

    # Get a hash suitable for building JSON, with the following keys:
    # :actual, :expected, :range, :type
    #
    # @return [Hash]
    def word_count_check text, level
      WordCountChecker.new(text, level).to_hash
    end
  end
end
