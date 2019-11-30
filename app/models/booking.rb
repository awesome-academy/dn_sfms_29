class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :subpitch
  has_one :rating, dependent: :destroy

  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :subpitch, prefix: true
  enum status: {cancel: -1, verifiled_paid: 0,
                verifiled_not_pay: 1, unverifile: 2}
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :subpitch_id, presence: true
  validates :total_price, presence: true
  validate :check_status, :check_exist, on: :payment

  delegate :full_name, to: :user, prefix: true
  delegate :name, to: :subpitch, prefix: true
  delegate :pitch, to: :subpitch
  delegate :name, to: :pitch, prefix: true
  delegate :address, to: :pitch, prefix: true

  scope(:today, lambda do
    where "date_format(start_time, \"%Y%m%d\") = ?",
          Time.zone.today.strftime("%Y%m%d")
  end)
  scope :recently, ->{order(created_at: :desc)}
  scope :search_name, (lambda do |search|
    includes(subpitch: :pitch).where("subpitches.name LIKE ?", "%#{search}%")
  end)

  scope :search_total, (lambda do |search|
    includes(:booking).where bookings: {total_price: search} if search
  end)
  private

  def check_status
    return unless (Booking.find_by id: id).verifiled_paid?

    errors.add :base, I18n.t("cant_repay")
  end

  def check_exist
    return unless Booking.find_by subpitch_id: subpitch_id,
      start_time: start_time, status: Booking.statuses[:verifiled_paid]

    errors.add :base, I18n.t("exist_paid_booking")
  end
end
