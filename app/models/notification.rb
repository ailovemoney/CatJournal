class Notification < ApplicationRecord
  # default_scopeは作成日時の降順で指定。常に新しい通知からデータを取得させるため。
  default_scope -> { order(created_at: :desc) }
  # optional: trueはnilの許可
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
end
