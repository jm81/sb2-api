class Story < Sequel::Model
  def validate
    super
    if level.blank? || level.to_i < 0
      errors.add(:level, 'must be a positive integer')
    end
  end
end
