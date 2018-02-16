class MemoryDate < ActiveRecord::Base
  validates :day, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 31, greater_than_or_equal_to: 1 }
  validates :month, presence: true, numericality: { only_integer: true, less_than_or_equal_to: 12, greater_than_or_equal_to: 1 }
  validates :year, numericality: { only_integer: true, allow_blank: true }

  KINDS = {
    'birth' => 'Родился',
    'death' => 'Умер',
    'other' => 'Другое'
  }

end
