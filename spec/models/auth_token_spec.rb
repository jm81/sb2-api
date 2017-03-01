require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  subject(:auth_token) { FactoryGirl.build(:auth_token) }

  it { is_expected.to be_valid }
end
