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

    it "triggers after_create_commit callback" do
        post = Post.new(title: "titulo", content: "contenido")
        allow_any_instance_of(Post).to receive(:broadcast_prepend_to).with('posts')
        post.save
    end
    
    it "triggers after_update_commit callback" do
        post = Post.create(title: "titulo", content: "contenido")
        allow_any_instance_of(Post).to receive(:broadcast_replace_to).with('posts')
        post.update(title: "Updated Post")
    end
    
    it "triggers after_destroy_commit callback" do
        post = Post.create(title: "titulo", content: "contenido")
        allow_any_instance_of(Post).to receive(:broadcast_remove_to).with('posts')
        post.destroy
    end
end
