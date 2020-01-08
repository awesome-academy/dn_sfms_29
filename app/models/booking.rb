class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :subpitch
  has_one :rating, dependent: :destroy

  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :subpitch, prefix: true
  enum status: {cancel: -1, verifiled_paid: 0,
                verifiled_not_pay: 1, unverifile: 2}

  scope :search_name, (lambda do |search|
    includes(subpitch: :pitch).where("subpitches.name LIKE ?", "%#{search}%")
  end)

  scope :search_total, (lambda do |search|
    where bookings: {total_price: search} if search
  end)
end
