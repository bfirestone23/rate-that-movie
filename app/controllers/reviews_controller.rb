class ReviewsController < ApplicationController

    get '/reviews' do
        @request
        erb :'reviews/reviews'
    end

    get '/reviews/new' do
        if logged_in?
            erb :'reviews/new'
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            redirect to '/'
        end
    end

    get '/reviews/:id' do
        if logged_in?
            @review = Review.find_by_id(params[:id])
            erb :'reviews/show'
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
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
            flash[:message] = "Please select or add a movie!"
            redirect to "/reviews/new"
        else
            @movie = Movie.create(params[:new_movie])
            @review = Review.create(params[:review])
            @review.user = @user
            @review.movie = @movie
            @review.save

            flash[:message] = "Review successfully created!"
        end
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
                flash[:message] = "Please select or add a movie!"
                redirect to "/reviews/#{@review.id}"
            else
                @movie = Movie.create(params[:new_movie])
                @review.movie = @movie
                @review.update(params[:review])
                @review.save

                flash[:message] = "Review successfully created!"
            end
        else  
            flash[:message] = "You do not have access to edit this review!"
            redirect to "/reviews/#{@review.id}"
        end
        redirect to "/reviews/#{@review.id}"
    end

    delete '/reviews/:id' do 
        if logged_in?
            @review = Review.find_by_id(params[:id])
            if @review && @review.user == current_user
                @review.destroy
                flash[:message] = "Review successfully deleted!"
                redirect to "/welcome/#{@review.user.slug}"
            else
                flash[:message] = "You do not have access to delete this review!"
                redirect to "/welcome/#{@review.user.slug}"
            end
        else
            flash[:message] = "You are not logged in!"
            redirect to "/"
        end
    end
end