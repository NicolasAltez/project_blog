require 'rails_helper'

RSpec.describe Comment, type: :model do
    it "associations validates" do
        should belong_to(:post)
        should belong_to(:user)
    end

    it "validates fields presence" do
        should validate_presence_of(:content)
    end
end