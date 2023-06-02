require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'Comments', type: :feature do

  include Capybara::DSL
  include Devise::Test::IntegrationHelpers

  let(:user) { User.create(email: 'test@example.com', password: 'password') }
  let!(:post) { Post.create(title: 'titulo', content: 'contenido', user: user) }

  before do
    login_as(user)
  end

  describe 'creating a comment' do
    context 'with valid data' do
      it 'creates a new comment' do
        visit posts_path(post)

        click_link 'Show'

        expect(page).to have_content(post.title)
        expect(page).to have_content(post.content)
        expect(page).to have_content('New Comment')

        fill_in 'Content', with: 'This is a new comment.'

        click_button 'Add Comment'

        expect(page).to have_content('This is a new comment.')
      end
    end

    context 'with invalid data' do
      it 'does not create a new comment' do
        visit posts_path(post)

        click_link 'Show'

        click_button 'Add Comment'

        fill_in 'Content', with: ''

        expect(page).to have_content("Content can't be blank")
      end
    end
  end

  describe 'editing a comment' do
    let!(:comment) { Comment.create(post: post, user: user, content: 'Old content') }

    context 'with valid data' do
      it 'updates the comment' do
        visit posts_path(post)

        click_link 'Show'

        click_link 'Edit'
        fill_in 'Content', with: 'Updated content'
        click_button 'Update Comment'

        expect(page).to have_content('Updated content')
      end
    end

    context 'with invalid data' do
      it 'does not update the comment' do
        visit posts_path(post)

        click_link 'Show'

        click_link 'Edit'
        fill_in 'Content', with: ''
        click_button 'Update Comment'

        expect(page).to have_content("Content can't be blank")
      end
    end
  end

  describe 'deleting a comment' do
    let!(:comment) { Comment.create(post: post, user: user, content: 'To be deleted') }

    it 'deletes the comment' do
      visit posts_path(post)
      click_link 'Show'

      click_button 'Delete'

      expect(page).not_to have_content('To be deleted')
    end
  end
end
