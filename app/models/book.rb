class Book < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :title, presence: true
  validates :body, presence: true

  def get_image(width = 100, height = 100)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(
        io: File.open(file_path),
        filename: 'default-image.jpg',
        content_type: 'image/jpeg'
      )
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
end
