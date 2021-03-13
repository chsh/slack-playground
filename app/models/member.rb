class Member < ApplicationRecord
  belongs_to :team
  belongs_to :user, optional: true
end
