require 'rails_helper'

RSpec.describe Post, type: :model do
    it "associations validates" do
        should belong_to(:user)
        should have_many(:comments).dependent(:destroy)
        should have_one_attached(:image)
    end

    it "validates fields presence" do
        should validate_presence_of(:title)
        should validate_presence_of(:content)
    end
end
