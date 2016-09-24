class User < ApplicationRecord
  before_save {self.email = self.email.downcase}
  has_many :booking
  validates :name,
            presence: true,
            length: {maximum: 80},
            format: {with: /\A[a-zA-Z ]+\z/}

  validates :email, presence: true,
            length: {maximum: 100},
            format: {with: /\A[\w\-.]+[@][a-z\d\-]+[\.[a-z\d\-]+]*[\.][a-z]+\z/i},
            uniqueness: {case_sensitive: false}

  validates :password, presence: true,
            length: {minimum: 6},
            format: {with: /[\d\W]/}


  has_secure_password

  def self.get_admins
    @all_users = User.where(Admin: true).all
  end


end
