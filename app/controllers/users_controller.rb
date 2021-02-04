class UsersController < ApplicationController

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        erb :'users/show'
    end

    get '/welcome/:slug' do
        if logged_in?
            @user = User.find_by_slug(params[:slug])
            erb :'users/welcome'
        else
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
            redirect to "/welcome/#{@user.slug}"
        else
            erb :'users/login'
        end
    end

    post '/login' do
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to "/welcome/#{@user.slug}"
        else
            redirect to '/signup'
        end
    end

    post '/logout' do 
        if logged_in?
            session.destroy
            redirect to "/login"
        else
            redirect to '/'
        end
    end

end