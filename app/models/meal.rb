class Meal < ActiveRecord::Base
  validates :name, presence: true
  validates :date, presence: true
  validates :time, presence: true
  validates :location, presence: true

  belongs_to :restaurant
  has_many :categories, through: :restaurants
  has_many :invitations
  has_many :users, through: :invitations
  has_many :votes
  belongs_to :host, class_name: "User", foreign_key: "host_id"

  def self.future_meals_by_user(user)
    self.all.select do |meal|
      meal.users.include?(user) && meal.date >= DateTime.now.to_date
    end
  end

  def create_invitations(user_ids)
    Invitation.create(user: self.host, meal: self)
    if user_ids
      users = user_ids.map{|user_id| User.find(user_id)}
      users.each do |user|
        Invitation.create(user: user, meal: self)
      end
    end
  end

  def create_votes(user, category_ids, value)
    if category_ids
      category_ids.each do |category_id|
        category = Category.find(category_id)
        Vote.create(user: user, meal: self, category: category, value: value)
      end
    end
  end

  def likes_by_user(user_id)
    self.votes
      .select{|vote| vote.user.id == user_id && vote.value > 0}
      .map{|vote| vote.category}
  end

  def dislikes_by_user(user_id)
    self.votes
      .select{|vote| vote.user.id == user_id && vote.value < 0}
      .map{|vote| vote.category}
  end

  def self.user_invited_to_meal?(user_id, meal_id)
    user = User.find(user_id)
    meal = Meal.find(meal_id)
    meal.users.include?(user)
  end

  def self.user_hosting_meal?(user_id, meal_id)
    user = User.find(user_id)
    meal = Meal.find(meal_id)
    meal.host == user
  end

  def destroy_stale_votes
    self.votes.each do |vote|
      vote.destroy unless self.users.include?(vote.user)
    end
  end

end