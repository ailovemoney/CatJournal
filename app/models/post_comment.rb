class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :notifications, dependent: :destroy
  
  # 投稿する際に、空欄を禁止する。
  validates :comment, presence: true
end
