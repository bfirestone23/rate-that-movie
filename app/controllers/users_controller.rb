class UsersController < ApplicationController

    get '/users/:slug' do
        redirect_if_not_logged_in

        @user = User.find_by_slug(params[:slug])
        @reviews = @user.reviews.sort { |a, b| b.created_at <=> a.created_at }

        erb :'users/show'
    end

    get '/welcome/:slug' do 
        @request
        
        redirect_if_not_logged_in

        @user = User.find_by_slug(params[:slug])

        if @user != current_user
            redirect to "/users/#{@user.slug}"
        end

        @users = User.all
        @reviews = @user.reviews.sort { |a, b| b.created_at <=> a.created_at }

        erb :'users/welcome'
    end

    get '/signup' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            flash[:message] = "You're already logged in!"
            redirect to "/welcome/#{@user.slug}"
        end

        erb :'users/signup'
    end

    post '/signup' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            flash[:message] = "You're already logged in!"
            redirect to "/welcome/#{@user.slug}"
        end

        if params[:username] == "" || params[:password] == "" || params[:email] == ""
            flash[:message] = "All fields are required."
            redirect to '/signup'
        end

        existing_user = User.find_by(username: params[:username])
        if existing_user
            flash[:message] = "User already exists."
            redirect to '/signup'
        end

        @user = User.create(params)
        session[:user_id] = @user.id
        
        redirect to "/welcome/#{@user.slug}"
    end

    get '/login' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            flash[:message] = "You're already logged in!"
            redirect to "/welcome/#{@user.slug}"
        end

        erb :'users/login'
    end

    post '/login' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            flash[:message] = "You're already logged in!"
            redirect to "/welcome/#{@user.slug}"
        end

        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to "/welcome/#{@user.slug}"
        else
            flash[:message] = "Invalid username or password. Hint: they're case-sensitive!"
            erb :'users/login'
        end
    end

    get '/logout' do 
        redirect_if_not_logged_in

        session.destroy
        flash[:message] = "Goodbye!"
        erb :index
    end

end