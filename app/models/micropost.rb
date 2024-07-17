class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :newest, ->{order(created_at: :desc)}

  VALID_ATTRIBUTES = %i(content image).freeze
  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("microposts.image_type")},
                    size: {less_than: Settings.img_size.megabytes,
                           message: I18n.t("microposts.image_size")}

  def display_image
    image.variant resize_to_limit: Settings.img_display_size
  end
end
