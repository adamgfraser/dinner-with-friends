require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    if session[:id]
      @user = User.find(session[:id])
      @meals = Meal.future_meals_by_user(@user)
      erb :index
    else
      redirect to '/login'
    end
  end

  get '/login' do
    if session[:id]
      redirect to '/'
    else
      erb :"users/login"
    end
  end

  post '/login' do
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect to '/'
    else
      redirect to '/login'
    end
  end

  get '/signup' do
    if session[:id]
      redirect to '/'
    else
      erb :"users/signup"
    end
  end

  post '/signup' do
    user = User.new(params)
    if user.save
      session[:id] = user.id
      redirect to '/'
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    session.clear
    redirect to '/'
  end

  get '/meals/new' do
    if session[:id]
      @categories = Category.all
      @users = User.others(session[:id])
      erb :"meals/new"
    else
      redirect to '/'
    end
  end

  post '/meals' do
    meal = Meal.new
    meal.host = User.find(session[:id])
    meal.name = params[:name]
    meal.date = params[:date]
    meal.time = params[:time]
    meal.location = params[:location]
    if meal.save
      meal.create_invitations(params[:guests])
      meal.create_votes(meal.host, params[:likes], 1)
      meal.create_votes(meal.host, params[:dislikes], -100)
      redirect to '/'
    else
      redirect to '/meals/new'
    end
  end

  get '/meals/:meal' do
    if session[:id] && Meal.user_invited_to_meal?(session[:id], params[:meal])
      @meal = Meal.find(params[:meal])
      @restaurant = @meal.restaurant
      erb :'meals/show'
    else
      redirect to '/'
    end
  end

  get '/meals/:meal/edit' do
    if session[:id] && Meal.user_hosting_meal?(session[:id], params[:meal])
      @meal = Meal.find(params[:meal])
      @categories = Category.all
      @likes = @meal.likes_by_user(session[:id])
      @dislikes = @meal.dislikes_by_user(session[:id])
      @users = User.others(session[:id])
      erb :'meals/edit'
    else
      redirect to '/'
    end
  end

  post '/meals/:meal' do
    meal = Meal.find(params[:meal])
    meal.name = params[:name]
    meal.date = params[:date]
    meal.time = params[:time]
    meal.location = params[:location]
    if meal.save
      meal.invitations.each{|invitation| invitation.destroy}
      meal.create_invitations(params[:guests])
      meal.destroy_stale_votes
      meal.host.votes.each{|vote| vote.destroy}
      meal.create_votes(meal.host, params[:likes], 1)
      meal.create_votes(meal.host, params[:dislikes], -100)
      redirect to '/'
    else
      redirect to "/meals/#{params[:meal]}/edit"
    end
  end

  post '/meals/:meal/delete' do
    meal = Meal.find(params[:meal])
    if Meal.user_hosting_meal?(session[:id], params[:meal])
      meal.destroy
    else
      meal.invitations.find_by(user: session[:id]).destroy
      meal.votes.select{|vote| vote.user == session[:id]}.each{|vote| vote.destroy}
    end
    redirect to '/'
  end  

  get '/meals/:meal/votes/new' do
    if session[:id]
      @meal = Meal.find(params[:meal])
      @categories = Category.all
      erb :'votes/new'
    else
      redirect to '/'
    end
  end

  post '/meals/:meal/votes' do
    user = User.find(session[:id])
    meal = Meal.find(params[:meal])
    meal.votes.select{|vote| vote.user == user}.each{|vote| vote.destroy}
    meal.create_votes(user, params[:likes], 1)
    meal.create_votes(user, params[:dislikes], -100)
    redirect to '/'
  end

  get '/meals/:meal/restaurants/:page' do
    @meal = Meal.find(params[:meal])
    recommender = Recommender.new(@meal)
    @page = params[:page].to_i
    restaurants = (1..@page).map do
      recommender.recommendation
    end
    @restaurant = restaurants.last
    erb :'restaurants'
  end

  post '/meals/:meal/restaurants/:restaurant' do
    meal = Meal.find(params[:meal])
    restaurant = Restaurant.find(params[:restaurant])
    meal.update(restaurant: restaurant)
    redirect to '/'
  end

end