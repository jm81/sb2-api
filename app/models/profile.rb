class Profile < Sequel::Model
  one_to_many :profile_memberships, class: :ProfileMember,
    key: :member_profile_id
  many_to_many :profiles, join_table: :profile_members,
    left_key: :member_profile_id

  plugin :validation_helpers

  # Validations for #handle follow twitter's requirements, because, hey, why
  # not? #display_name is required and otherwise has no rules.
  def validate
    validates_presence [:handle, :display_name]
    validates_max_length 15, :handle
    validates_format(/\A[a-zA-Z0-9_]{1,15}\Z/, :handle)
    validates_max_length 40, :display_name

    # handle case-insensitive unique
    # http://stackoverflow.com/questions/11442733
    dataset = model.where{ |o| {o.lower(:handle)=>o.lower(handle)}}
    dataset.exclude(pk_hash) unless new?
    errors.add(:handle, 'is already taken') unless 0 == dataset.count
  end
end
