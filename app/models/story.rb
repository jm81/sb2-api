class Story < Sequel::Model
  include ActiveModel::SerializerSupport

  plugin :validation_helpers

  many_to_one :author, class: :Profile

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
