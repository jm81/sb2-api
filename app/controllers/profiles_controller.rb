class ProfilesController < APIController
  wrap_parameters :profile, include: [:handle, :display_name], format: :json

  version 1

  before_action :require_authenticated

  def create
    profile = Profile.new profile_params
    if profile.valid?
      profile.save
      current_user.add_profile_membership profile: profile
      expose profile, serializer: ProfileSerializer
    else
      error! :invalid_resource, profile.errors
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:handle, :display_name)
  end
end
