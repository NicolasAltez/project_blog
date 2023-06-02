require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:valid_attributes) { attributes_for(:post) }
  let(:invalid_attributes) { { title: '', content: '' } }

  before { sign_in user }

  describe 'GET index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @posts with all posts' do
      post1 = create(:post, user: user)
      post2 = create(:post, user: user)
      get :index
      expect(assigns(:posts)).to match_array([post1, post2])
    end
  end

  describe 'GET show' do
    it 'returns a successful response' do
      get :show, params: { id: post.id }
      expect(response).to be_successful
    end
  
    it 'assigns @comment as a new Comment' do
      get :show, params: { id: post.id }
      expect(assigns(:comment)).to be_a_new(Comment)
    end
  
    it 'assigns @post with the correct post' do
      get :show, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'GET new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new Post to @post' do
      get :new
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe 'POST create' do
    context 'with valid parameters' do
      it 'creates a new post' do
        expect {
          post :create, params: { post: valid_attributes } 
        }.to change(Post, :count).by(1)
      end

      it 'redirects to the posts index' do
        post :create, params: { post: valid_attributes } 
        expect(response).to redirect_to(posts_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new post' do
        expect {
          post :create, params: { post: invalid_attributes }
        }.to_not change(Post, :count)
      end

      it 'renders the new template' do
        post :create, params: { post: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET edit' do
    it 'returns a successful response' do
      get :edit, params: { id: post.id }
      expect(response).to be_successful
    end

    it 'assigns @post with the correct post' do
      get :edit, params: { id: post.id }
      expect(assigns(:post)).to eq(post)
    end
  end

  describe 'PATCH update' do
    context 'with valid parameters' do
      it 'updates the post' do
        patch :update, params: { id: post.id, post: { title: 'Titulo actualizado' } }
        post.reload
        expect(post.title).to eq('Titulo actualizado')
      end

      it 'redirects to the posts index' do
        patch :update, params: { id: post.id, post: { title: valid_attributes } }
        expect(response).to redirect_to(posts_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the post' do
        patch :update, params: { id: post.id, post: { title: invalid_attributes } }
        post.reload
        expect(post.title).not_to eq('')
      end

      it 'renders the edit template' do
        patch :update, params: { id: post.id, post: { title: invalid_attributes } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the post' do
      expect {
        delete :destroy, params: { id: post.id }
      }.to change(Post, :count).by(-1)
    end

    it 'redirects to the posts index' do
      delete :destroy, params: { id: post.id }
      expect(response).to redirect_to(posts_path)
    end
  end
end
