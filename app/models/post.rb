class Post < ApplicationRecord
  # 複数のimage(画像)を持たせる
  has_many_attached :image
  # userモデルと1:N (N側)
  belongs_to :user
end
