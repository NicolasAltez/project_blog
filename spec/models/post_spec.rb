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

    it "purges the image if attached" do
        post = Post.new
        image = double("image")

        allow(post).to receive(:image).and_return(image)
        allow(image).to receive(:attached?).and_return(true)
        allow(image).to receive(:purge)
        allow(image).to receive(:nil?).and_return(true)
  
        post.send(:purge_image)
  
        expect(post.image).to be_nil
    end
  
    it "does not purge the image if not attached" do
        post = Post.new
        image = double("image")

        allow(post).to receive(:image).and_return(image)
        allow(image).to receive(:attached?).and_return(false)

        expect(image).not_to receive(:purge)
  
        post.send(:purge_image)

        expect(post.image).not_to be_nil
    end

    it "triggers purge_image" do
        post = Post.new

        expect(post).to receive(:purge_image)

        post.run_callbacks(:destroy)
    end
end
