class Recommender

  def initialize(meal)
    @meal = meal
    @categories = Category.all
    @yelp_client = YelpClient.new
    @top_categories = []
    @restaurants = []
  end

  def recommendation
    if @restaurants.empty?
      @top_categories = top_categories
      @categories = @categories - @top_categories
      category_filter = @top_categories.map {|category| category.yelp_alias}.join(",")
      params = {category_filter: category_filter}
      results = @yelp_client.search(@meal.location, params)
      @restaurants = results.map do |result|
        Restaurant.create_from_yelp_search_result(result)
      end
      recommendation
    else
      restaurant = @restaurants.first
      @restaurants = @restaurants[1..-1]
      restaurant
    end
  end

  def top_categories
    categories_with_votes = @categories.map{|category| [category, 0]}.to_h
    @meal.votes.each do |vote|
      categories_with_votes[vote.category] += vote.value
    end
    max_votes = categories_with_votes.values.max
    categories_with_votes
      .select {|category, votes| votes == max_votes}
      .keys
  end

end