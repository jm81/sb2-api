require 'rails_helper'

RSpec.describe AuthMethod, type: :model do
  subject(:auth_method) { FactoryGirl.build(:auth_method) }

  it { is_expected.to be_valid }
end
