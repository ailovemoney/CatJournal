class Post < ApplicationRecord
  # image(画像)を持たせる
  has_one_attached :image
  # userモデルと1:N (N側)
  belongs_to :user
  # commentモデルと1:N (1側)
  has_many :post_comments, dependent: :destroy

  # 投稿時に画像がない場合
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end

end
