require 'rails_helper'

RSpec.describe User, type: :model do
    it "associations validates" do
        should have_many(:posts).dependent(:destroy)
        should have_many(:comments).dependent(:destroy)
    end

    it "validates fields presence" do
        should validate_presence_of(:email)
        should validate_presence_of(:password)
    end
end