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

  private

  # If @direction is set, set level in relation to parent.
  def set_level_from_direction
    return nil unless parent

    case @direction
    when '+'
      self.level = parent.level + 1
    when '-'
      self.level = parent.level - 1
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
