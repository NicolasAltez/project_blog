require 'rails_helper'

RSpec.describe CommentsController, type: :controller do


  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:valid_attributes) { attributes_for(:comment) }
  let(:invalid_attributes) { { content: '' } }
  let!(:comment) { create(:comment, post: post, user: user) }

  before { sign_in user }

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new comment" do
        expect {
          post :create, params: { post_id: post.id, comment: valid_attributes }
        }.to change(Comment, :count).by(1)
      end

      it "redirects to the post" do
        post :create, params: { post_id: post.id, comment: valid_attributes }
        expect(response).to redirect_to(post_path(post))
      end
    end

    context "with invalid parameters" do
      it "does not create a new comment" do
        expect {
          post :create, params: { post_id: post.id, comment: invalid_attributes }
        }.not_to change(Comment, :count)
      end

      it "redirects to the post" do
        post :create, params: { post_id: post.id, comment: invalid_attributes }
        expect(response).to redirect_to(post_path(post))
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested comment to @comment" do
      get :edit, params: { post_id: post.id, id: comment.id }
      expect(assigns(:comment)).to eq(comment)
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the comment" do
        patch :update, params: { post_id: post.id, id: comment.id, comment: valid_attributes }
        comment.reload
        expect(comment.content).to eq(valid_attributes[:content])
      end

      it "redirects to the post" do
        patch :update, params: { post_id: post.id, id: comment.id, comment: valid_attributes }
        expect(response).to redirect_to(post_path(post))
      end
    end

    context "with invalid parameters" do
      it "does not update the comment" do
        patch :update, params: { post_id: post.id, id: comment.id, comment: invalid_attributes }
        comment.reload
        expect(comment.content).not_to eq(invalid_attributes[:content])
      end

      it "renders the edit template" do
        patch :update, params: { post_id: post.id, id: comment.id, comment: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the comment" do
      expect {
        delete :destroy, params: { post_id: post.id, id: comment.id }
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the post" do
      delete :destroy, params: { post_id: post.id, id: comment.id }
      expect(response).to redirect_to(post_path(post))
    end
  end
end
