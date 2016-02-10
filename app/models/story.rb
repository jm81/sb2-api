class Story < Sequel::Model
  include ActiveModel::SerializerSupport

  plugin :validation_helpers

  many_to_one :author, class: :Profile
  many_to_one :parent, class: :Story
  one_to_many :children, class: :Story, key: :parent_id

  # Set body and words (word count) from value.
  #
  # @param value [String] Body (text) of story.
  def body= value
    self.words = self.class.word_count value
    super
  end

  private

  def validate
    super

    validates_presence :author

    if level.blank? || level.to_i < 0
      errors.add(:level, 'must be a positive integer')
    end
  end

  class << self
    # Get word count for text, using Microsoft Word standard.
    #
    # @return [Integer] Word count.
    def word_count text
      WordCountAnalyzer::Counter.new(text: text).mword_count
    end
  end
end
