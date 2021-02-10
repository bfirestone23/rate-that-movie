class UsersController < ApplicationController

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        erb :'users/show'
    end

    get '/welcome/:slug' do 
        @request
        if logged_in?
            @user = User.find_by_slug(params[:slug])
            @users = User.all
            if @user == current_user
                erb :'users/welcome'
            else
                redirect to "/users/#{@user.slug}"
            end
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            redirect to '/'
        end
    end

    get '/signup' do
        erb :'users/signup'
    end

    post '/signup' do
        if params[:username] == "" || params[:password] == "" || params[:email] == ""
            redirect to '/signup'
        else
            existing_user = User.find_by(username: params[:username])
            if existing_user
                flash[:message] = "User already exists."
                redirect to '/signup'
            else
                @user = User.create(params)
                session[:user_id] = @user.id
                erb :'users/welcome'
            end
        end
    end

    get '/login' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            flash[:message] = "You're already logged in!"
            redirect to "/welcome/#{@user.slug}"
        else
            erb :'users/login'
        end
    end

    post '/login' do
        username = params[:username].downcase
        @user = User.find_by(username: username)

        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to "/welcome/#{@user.slug}"
        elsif !@user.authenticate(params[:password]) || @user.username != username
            flash[:message] = "Invalid username or password."
            redirect to '/login'
        else
            redirect to '/login'
        end
    end

    get '/logout' do 
        if logged_in?
            session.destroy
            redirect to "/"
        else
            redirect to '/'
        end
    end

end