class User < Sequel::Model
  include Jm81auth::Models::User

  one_to_many :profile_memberships, class: :ProfileMember, key: :member_user_id
  many_to_many :profiles, join_table: :profile_members,
    left_key: :member_user_id

  # @return [Profile] Default profile, currently the first profile.
  def default_profile
    profiles_dataset.order(:id).first
  end
end
