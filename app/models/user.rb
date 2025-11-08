class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_writer :login

  def login
    @login || self.name
  end

  has_many :books, dependent: :destroy
  has_one_attached :profile_image

  # バリデーション
  validates :name,
            presence: true,
            uniqueness: true,
            length: { minimum: 2, maximum: 20 }
  validates :introduction,
            length: { maximum: 50 }

  # プロフィール画像取得用メソッド
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'no-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (name = conditions.delete(:login))
      where(conditions.to_h).where(["name = :value", { value: name }]).first
    else
      where(conditions.to_h).first
    end
  end
end