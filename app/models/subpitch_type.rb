class SubpitchType < ApplicationRecord
  TYPE = %i(name description).freeze

  has_many :subpitches, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.size.s50}
  validates :description, length: {maximum: Settings.size.s255}
end
