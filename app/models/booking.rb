class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :subpitch
  has_one :rating, dependent: :destroy

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :subpitch_id, presence: true
  validates :total_price, presence: true
  validate :check_status, on: :payment
  validate :check_exist, on: :payment

  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :subpitch, prefix: true
  enum status: {cancel: -1, verifiled_paid: 0,
                verifiled_not_pay: 1, unverifile: 2}

  scope :search_name, (lambda do |search|
    includes(subpitch: :pitch).where("subpitches.name LIKE ?", "%#{search}%")
  end)

  scope :search_total, (lambda do |search|
    includes(:booking).where bookings: {total_price: search} if search
  end)

  private

  def check_status
    return unless Booking.statuses[(Booking.find_by id: id).status].zero?

    errors.add :base, I18n.t("cant_repay")
  end

  def check_exist
    return unless Booking.find_by subpitch_id: subpitch_id,
      start_time: start_time, status: Settings.paid_status_booking

    errors.add :base, I18n.t("exist_paid_booking")
  end
end
