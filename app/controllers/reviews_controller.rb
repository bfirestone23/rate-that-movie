class ReviewsController < ApplicationController

    get '/reviews' do
        erb :'reviews/reviews'
    end

    get '/reviews/new' do
        if logged_in?
            erb :'reviews/new'
        else
            redirect to '/index'
        end
    end

    get '/reviews/:id' do
        @review = Review.find_by_id(params[:id])
        erb :'reviews/show'
    end

    get '/reviews/:id/edit' do
        @review = Review.find_by_id(params[:id])
        erb :'reviews/edit'
    end

    post '/reviews' do
        @user = User.find_by_id(session[:user_id])
        if params[:existing_movie]
            @movie = Movie.find_by_id(params[:existing_movie][:movie_id])
            @review = Review.create(params[:review])
            @review.user = @user
            @review.movie = @movie
            @review.save
        else
            @movie = Movie.create(params[:new_movie])
            @review = Review.create(params[:review])
            @review.user = @user
            @review.movie = @movie
            @review.save
        end
        redirect to "/reviews/#{@review.id}"
    end

    delete '/reviews/:id' do 
        if logged_in?
            @review = Review.find_by_id(params[:id])
            if @review && @review.user == current_user
                @review.destroy
                redirect to "/welcome/#{@review.user.slug}"
            else
                redirect to "/welcome/#{@review.user.slug}"
            end
        else
            redirect to "/index"
        end
    end
end