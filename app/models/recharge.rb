class Recharge < ApplicationRecord
  belongs_to :sender, class_name: User.name
  belongs_to :receiver, class_name: User.name
  validates :sender_id, presence: true
  validates :receiver_id, presence: true
  validates :money, numericality: true
  validate :check_money

  private

  def check_money
    return if self.money.nil?
    return if self.money > 0

    errors.add :money_invalid, I18n.t("msg.money_invalid")
  end
end
