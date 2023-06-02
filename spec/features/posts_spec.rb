require 'rails_helper'
require 'capybara/rspec'

RSpec.describe 'Posts', type: :feature do

  include Capybara::DSL
  include Devise::Test::IntegrationHelpers

  let(:user) { User.create(email: 'nico@gmail', password: 'password') }
  let!(:post) { Post.create(title: 'titulo', content: 'contenido', user: user) }

  before do
    login_as(user)
  end

  describe 'index page' do
    it 'displays the list of posts' do
      visit posts_path

      expect(page).to have_content('Posts')
      expect(page).to have_content('titulo')
      expect(page).to have_content('contenido')
    end

    it 'displays a message when there are no posts' do
      Post.destroy_all

      visit posts_path

      expect(page).to have_content('No posts available.')
    end

    it 'redirects to the new post form' do
      visit posts_path
      click_link 'New Post'

      expect(page).to have_content('New Post')
      expect(page).to have_selector('form#new_post')
    end
  end

  describe 'new post form' do
    it 'creates a new post with valid data' do
      visit new_post_path

      fill_in 'Title', with: 'nuevo post'
      fill_in 'Content', with: 'nuevo contenido'
      click_button 'Create Post'

      expect(page).to have_content('nuevo post')
      expect(page).to have_content('nuevo contenido')
    end

    it 'displays errors when creating a post with invalid data' do
      visit new_post_path

      click_button 'Create Post'

      expect(page).to have_content('prohibited this post from being saved:')
      expect(page).to have_content("Title can't be blank")
    end
  end

  describe 'edit post form' do
    it 'updates a post with valid data' do
      visit edit_post_path(post)

      fill_in 'Title', with: 'actualizar test'
      fill_in 'Content', with: 'actualizar contenido'
      click_button 'Update Post'

      expect(page).to have_content('actualizar test')
      expect(page).to have_content('actualizar contenido')
    end

    it 'displays errors when updating a post with invalid data' do
      visit edit_post_path(post)

      fill_in 'Title', with: ''
      click_button 'Update Post'

      expect(page).to have_content('prohibited this post from being saved:')
      expect(page).to have_content("Title can't be blank")
    end
  end

  describe 'delete post' do
    it 'deletes a post' do
      visit posts_path

      expect(page).to have_content('titulo')
      expect(page).to have_content('contenido')

      click_button 'Delete'

      expect(page).not_to have_content('titulo')
      expect(page).not_to have_content('contenido')
    end
  end
end
