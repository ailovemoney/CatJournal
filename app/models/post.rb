class Post < ApplicationRecord
  # image(画像)を持たせる
  has_one_attached :image
  # userモデルと1:N (N側)
  belongs_to :user
  # commentモデルと1:N (1側)
  has_many :post_comments, dependent: :destroy
  # favorite(いいね機能)
  has_many :favorites, dependent: :destroy
  # ジャンル
  belongs_to :genre

  # 投稿時に画像がない場合の処理
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
  
  # 投稿する際に、空欄を禁止する。
  validates :title, presence: true
  validates :body, presence: true

  # いいね機能
  # ユーザーIDがFavaritedテーブル内に存在するか調べる記述
  # 存在していればtrue、なければfalseで返す。
  # 管理者でログインしている場合にエラーが出るのでif文で条件追記。
  def favorited_by?(user)
    # userログインをしているかどうかの
    if user.present?
      favorites.exists?(user_id: user.id)
    else
      # userログインしていない場合は無条件にfalseを返します。
      false
    end
  end

  # コメント機能
  # コメントしている場合、一覧でアイコンを変えるための
  def comment_by?(user)
    post_comments.exists?(user_id: user.id)
  end

  # ワード検索用の記述
  def self.search(word)
    Post.where(['title LIKE(?) OR body LIKE(?)', "%#{word}%", "%#{word}%"])
  end

end
