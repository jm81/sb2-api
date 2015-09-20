class ProfileMember < Sequel::Model
  plugin :validation_helpers

  many_to_one :profile
  many_to_one :member_profile, class: :Profile
  many_to_one :member_user, class: :User
  many_to_one :added_by, class: :Profile

  # Get the member, which is either a Profile or a User. A profile can be a
  # member of another profile (probably a group profile but not necessarily).
  # A profile can also have users as direct members, the most likely case being
  # the primary profile(s) of the User.
  #
  # @return [Profile, User]
  def member
    member_profile || member_user
  end

  def validate
    validates_presence [:profile]
  end
end
