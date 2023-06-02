class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_one_attached :image
    validates :title, :content, presence: true

    after_create_commit { broadcast_prepend_to 'posts' }
    after_update_commit { broadcast_replace_to 'posts' }
    after_destroy_commit { broadcast_remove_to 'posts' }
end
