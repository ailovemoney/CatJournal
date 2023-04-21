class Post < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :genre
  has_many :notifications, dependent: :destroy

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
    # userログインをしているかどうかの判断
    if user.present?
      favorites.exists?(user_id: user.id)
    else
      # userログインしていない場合は無条件にfalseを返します。
      false
    end
  end

  # コメント機能
  # コメントしている場合、一覧でアイコンを変えるための記述
  def comment_by?(user)
    if user.present?
      post_comments.exists?(user_id: user.id)
    else
      false
    end
  end

  # ワード検索用の記述
  def self.search(word)
    Post.where(['title LIKE(?) OR body LIKE(?)', "%#{word}%", "%#{word}%"])
  end

  # 通知機能（いいね）
  def create_notification_like!(current_user)
    # すでに「いいね」されているか検索
    # いいねボタン連打した時とかに、押した数だけ通知が行かないようにレコードのチェックを行う。
    # ？はプレースホルダ。「？」を指定した値で置き換えることができる
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  # 通知機能（コメント）
  def create_notification_post_comment!(current_user, post_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_post_comment!(current_user, post_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_post_comment!(current_user, post_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, post_comment_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user.id, id, 'post_comment'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user.id,
        action: 'post_comment'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

end
