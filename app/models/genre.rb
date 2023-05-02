class Genre < ApplicationRecord
  has_many :posts, dependent: :destroy
  
  # 投稿する際に、空欄を禁止する。
  validates :name, presence: true
end
