require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  subject { create(:subscriber) }

  it { should belong_to(:user) }
  it { should belong_to(:question) }
  it { should validate_uniqueness_of(:question).scoped_to(:user_id) }
end
