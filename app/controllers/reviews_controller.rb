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

    post '/reviews' do
        @user = User.find_by_id(session[:user_id])
        if params[:existing_movie]
            @movie = Movie.find_by_id(params[:existing_movie][:movie_id])
            @review = Review.create(watch_date: params[:review][:watch_date], rating: params[:review][:rating], description: params[:review][:description])
            @review.user = @user
            @review.movie = @movie
            @review.save
        else
            @movie = Movie.create(title: params[:new_movie][:title], genre: params[:new_movie][:genre], director: params[:new_movie][:director], release_date: params[:new_movie][:release_date])
            @review = Review.create(watch_date: params[:review][:watch_date], rating: params[:review][:rating], description: params[:review][:description])
            @review.user = @user
            @review.movie = @movie
            @review.save
        end
        redirect to "/reviews/#{@review.id}"
    end
end