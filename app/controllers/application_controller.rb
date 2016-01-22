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
      @meals = Meal.all
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

  get '/meals' do
    erb :"meals/new"
  end

  get '/meals/new' do
    if session[:id]
      @meals = Meal.all
      erb :"users"
    else
      redirect to '/'
    end
  end

  post '/meals' do
    meal = Meal.new
    meal.name = params[:name]
    meal.date = params[:date]
    meal.time = params[:time]
    if meal.save
      params[:users].each do |user_id|
        invitation = Invitation.new
        user = User.find(user_id)
        invitation.user = user
        invitation.meal = meal
        invitation.save
      end
      redirect to '/meals'
    else
      redirect to '/meals/new'
    end
  end

  get '/votes/new' do
  end

  post '/votes' do
  end

end