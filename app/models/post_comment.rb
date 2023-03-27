class PostComment < ApplicationRecord
  # userモデルとpostモデル1:N (N側)
  belongs_to :user
  belongs_to :post
  # 通知機能
  has_many :notifications, dependent: :destroy
end
