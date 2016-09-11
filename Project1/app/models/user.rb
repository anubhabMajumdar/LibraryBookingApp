class User < ApplicationRecord
  validates :name, presence: true, length: {maximum: 80}, format: {with: /\A[a-zA-Z ]+\z/}

  validates :email, presence: true

end
