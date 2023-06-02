require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'user abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil } 

    context 'when user is an admin' do
      let(:user) { create(:user, admin: true) }

      it { is_expected.to be_able_to(:manage, :all) }
    end

    context 'when user is not an admin' do
      let(:user) { create(:user, admin: false) }
      let(:post) { create(:post, user: user) }
      let(:other_user) { create(:user) }
      let(:own_post) { create(:post, user: user) }
      let(:other_post) { create(:post,user: other_user) }
      let(:own_comment) { create(:comment, post: post, user: user) }
      let(:other_comment) { create(:comment, post: post, user: other_user) }

      it 'has read and create abilities for posts' do
        is_expected.to be_able_to(:read, Post)
        is_expected.to be_able_to(:create, Post)
      end

      it 'has update and destroy abilities for own posts' do
        is_expected.to be_able_to(:update, own_post)
        is_expected.not_to be_able_to(:update, other_post)
        is_expected.to be_able_to(:destroy, own_post)
        is_expected.not_to be_able_to(:destroy, other_post)
      end

      it 'has read and create abilities for comments' do
        is_expected.to be_able_to(:read, Comment)
        is_expected.to be_able_to(:create, Comment)
      end

      it 'has update and destroy abilities for own comments' do
        is_expected.to be_able_to(:update, own_comment)
        is_expected.not_to be_able_to(:update, other_comment)
        is_expected.to be_able_to(:destroy, own_comment)
        is_expected.not_to be_able_to(:destroy, other_comment)
      end
    end
  end
end
