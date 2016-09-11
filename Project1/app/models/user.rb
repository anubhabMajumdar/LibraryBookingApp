class User < ApplicationRecord
  before_save {self.email = self.email.downcase}
  validates :name,
            presence: true,
            length: {maximum: 80},
            format: {with: /\A[a-zA-Z ]+\z/}

  validates :email, presence: true,
            length: {maximum: 100},
            format: {with: /\A[\w\-.]+[@][a-z\d\-]+[\.[a-z\d\-]+]*[\.][a-z]+\z/i},
            uniqueness: {case_sensitive: false}



end
