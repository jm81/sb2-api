class Story < Sequel::Model
  plugin :validation_helpers

  many_to_one :author, class: :Profile

  def validate
    super

    validates_presence :author

    if level.blank? || level.to_i < 0
      errors.add(:level, 'must be a positive integer')
    end
  end
end
