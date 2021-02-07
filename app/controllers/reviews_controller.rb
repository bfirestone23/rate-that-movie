class ReviewsController < ApplicationController

    get '/reviews' do
        @request
        erb :'reviews/reviews'
    end

    get '/reviews/new' do
        if logged_in?
            erb :'reviews/new'
        else
            redirect to '/'
        end
    end

    get '/reviews/:id' do
        if logged_in?
            @review = Review.find_by_id(params[:id])
            erb :'reviews/show'
        else
            redirect to '/'
        end
    end

    get '/reviews/:id/edit' do
        @review = Review.find_by_id(params[:id])
        @user = @review.user
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
        elsif !params[:existing_movie] && !params[:new_movie][:title] == ""
            #Flash msg: No movie added
            redirect to "/reviews/new"
        else
            @movie = Movie.create(params[:new_movie])
            @review = Review.create(params[:review])
            @review.user = @user
            @review.movie = @movie
            @review.save
        end
        #Flash msg: Review created
        redirect to "/reviews/#{@review.id}"
    end

    patch '/reviews/:id' do
        @user = User.find_by_id(session[:user_id])
        @review = Review.find_by_id(params[:id])
        if @user == current_user
            if params[:existing_movie]
                @movie = Movie.find_by_id(params[:existing_movie][:movie_id])
                @review.movie = @movie
                @review.update(params[:review])
                @review.save
            elsif !params[:existing_movie] && !params[:new_movie][:title] == ""
                #Flash msg: No movie added
                redirect to "/reviews/#{@review.id}"
            else
                @movie = Movie.create(params[:new_movie])
                @review.movie = @movie
                @review.update(params[:review])
                @review.save
            end
        else
            #Flash msg: You do not own this review
            redirect to "/reviews/#{@review.id}"
        end
        #Flash msg: Review updated
        redirect to "/reviews/#{@review.id}"
    end

    delete '/reviews/:id' do 
        if logged_in?
            @review = Review.find_by_id(params[:id])
            if @review && @review.user == current_user
                @review.destroy
                #Flash msg: Review deleted
                redirect to "/welcome/#{@review.user.slug}"
            else
                #Flash msg: You do not own this review
                redirect to "/welcome/#{@review.user.slug}"
            end
        else
            #Flash msg: You are not logged in
            redirect to "/"
        end
    end
end