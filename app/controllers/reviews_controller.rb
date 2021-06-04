class ReviewsController < ApplicationController

    get '/reviews' do
        redirect_if_not_logged_in

        @request
        @reviews = Review.all.sort { |a, b| b.created_at <=> a.created_at }
        
        erb :'reviews/reviews'
    end

    get '/reviews/new' do
        redirect_if_not_logged_in
        
        @movies = Movie.all.sort { |a, b| a.title <=> b.title }
        erb :'reviews/new'
    end

    get '/reviews/:id' do
        redirect_if_not_logged_in
        
        @review = Review.find_by_id(params[:id])
        erb :'reviews/show'
    end

    get '/reviews/:id/edit' do
        redirect_if_not_logged_in
        
        @review = Review.find_by_id(params[:id])
        @user = @review.user

        if logged_in? && @user == current_user
            erb :'reviews/edit'
        else 
            flash[:message] = "You do not have permission to edit this review."
            redirect to "/reviews/#{params[:id]}"
        end
    end

    post '/reviews' do
        redirect_if_not_logged_in

        @user = User.find_by_id(session[:user_id])
        
        if params[:existing_movie]
            @movie = Movie.find_by_id(params[:existing_movie][:movie_id])
            @review = Review.create(params[:review])
            @review.user = @user
            @review.movie = @movie
            @review.save
        elsif params[:new_movie][:title] == ""
            flash[:message] = "Please add a movie!"
            redirect to "/reviews/new"
        else
            @movie = Movie.create(params[:new_movie])

            if params[:review][:rating] == ""
                flash[:message] = "Please add a rating!"
                redirect to "/reviews/new"
            else
                @review = Review.create(params[:review])
                @review.user = @user
                @review.movie = @movie
                @review.save

                flash[:message] = "Review successfully created!"
            end
        end
        redirect to "/reviews/#{@review.id}"
    end

    patch '/reviews/:id' do
        redirect_if_not_logged_in

        @user = User.find_by_id(session[:user_id])
        @review = Review.find_by_id(params[:id])

        if @user == current_user
            @review.update(params[:review])
            @review.save

            flash[:message] = "Review successfully updated!"
            redirect to "/reviews/#{@review.id}"
        else  
            flash[:message] = "You do not have access to edit this review!"
            redirect to "/reviews/#{@review.id}"
        end
    end

    delete '/reviews/:id' do 
        redirect_if_not_logged_in

        @review = Review.find_by_id(params[:id])
        if @review && @review.user == current_user
            @review.destroy
            flash[:message] = "Review successfully deleted!"
            redirect to "/welcome/#{@review.user.slug}"
        else
            flash[:message] = "You do not have access to delete this review!"
            redirect to "/welcome/#{@review.user.slug}"
        end
    end
end