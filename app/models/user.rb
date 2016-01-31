class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  has_secure_password

  has_many :invitations
  has_many :meals, through: :invitations
  has_many :votes
  has_many :hosted_meals, class_name: "Meal", foreign_key: "host_id"

  def name
    "#{first_name} #{last_name}"
  end

  def self.others(user_id)
    self.all.select{|user| user.id != user_id}
  end

end