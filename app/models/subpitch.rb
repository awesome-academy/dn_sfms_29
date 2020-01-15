class Subpitch < ApplicationRecord
  PARAMS = %i(name description status price_per_hour currency
            picture size pitch_id subpitch_type_id).freeze
  belongs_to :pitch
  belongs_to :subpitch_type
  has_many :bookings, dependent: :destroy
  has_many :ratings, through: :bookings
  has_many :comments, through: :ratings
  has_many :likes, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.size.s50}
  validates :description, length: {maximum: Settings.size.s255}
  validates :price_per_hour, presence: true, numericality: true
  validates :size, presence: true, length: {maximum: Settings.size.s50}

  delegate :name, to: :pitch, prefix: true
  delegate :name, to: :subpitch_type, prefix: true
  has_one_attached :picture

  scope :by_pitch, ->(pitch_id){where pitch_id: pitch_id}

  scope :revenue_subpitch, (lambda do |pitch|
    joins(:bookings).where("subpitches.pitch_id = ?", pitch)
                    .select("subpitches.*, sum(bookings.total_price) as total")
                    .group("subpitches.id")
  end)
end
