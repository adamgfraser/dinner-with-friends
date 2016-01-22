class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  has_secure_password

  has_many :invitations
  has_many :meals, through: :invitations
  has_many :votes

  def name
    "#{first_name} #{last_name}"
  end

end