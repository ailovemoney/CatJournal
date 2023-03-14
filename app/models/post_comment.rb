class PostComment < ApplicationRecord
  # userモデルとpostモデル1:N (N側)
  belongs_to :user
  belongs_to :post
end
