class SubpitchType < ApplicationRecord
  TYPE = %i(name description).freeze

  has_many :subpitch, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.size.s50}
  validates :description, length: {maximum: Settings.size.s255}

  scope :search, (lambda do |subpitch_type_name|
    where("name LIKE ?", "%#{subpitch_type_name}%") if subpitch_type_name
  end)
end
