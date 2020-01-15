class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable
  has_many :comments, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :pitches, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_ratings, dependent: :destroy
  has_many :active_recharge, class_name: Recharge.name,
                             foreign_key: :sender_id, dependent: :destroy
  has_many :passive_recharge, class_name: Recharge.name,
                              foreign_key: :receiver_id, dependent: :destroy

  has_many :receiver, through: :active_recharge
  has_many :sender, through: :passive_recharge

  before_save{email.downcase!}
  DATA_TYPE_USERS = %i(full_name email password password_confirmation).freeze
  DATA_TYPE_UPDATE_PROFILE =
    %i(full_name phone gender).freeze
  VALID_PHONE_REGEX = /\A[\d]{10,}\z/i.freeze

  has_one_attached :avatar
  validates :full_name, presence: true,
    length: {maximum: Settings.name_in_users_max}
  validates :email, presence: true,
    length: {maximum: Settings.email_in_users_max},
    uniqueness: {case_sensitive: false}
  validates :phone, presence: true, on: :update, allow_nil: true
  validates :gender, inclusion: {in: [true, false],
                                 message: "Gender is valid"}, on: :update, allow_nil: true
  validates :wallet, numericality: {greater_than_or_equal_to: 0},
    allow_nil: true

  enum role: {admin: 0, owner: 1, user: 2}
  scope :order_confirm, ->{order("confirmed_at DESC")}
  scope :not_user, ->(user_id){where "id NOT IN (?)", user_id}
end
