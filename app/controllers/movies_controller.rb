class MoviesController < ApplicationController

    get '/movies' do
        redirect_if_not_logged_in

        @request
        @movies = Movie.all.sort { |a, b| a.title <=> b.title }
        
        erb :'movies/movies'
    end

    get '/movies/new' do
        redirect_if_not_logged_in

        erb :'movies/new'
    end

    get '/movies/:slug' do
        redirect_if_not_logged_in

        @movie = Movie.find_by_slug(params[:slug])

        if @movie
            @reviews = @movie.reviews.sort { |a, b| b.created_at <=> a.created_at }
            erb :'movies/show'
        else
            flash[:message] = "That movie does not exist."
            erb :'movies/movies'
        end
    end

    get '/movies/:slug/edit' do
        redirect_if_not_logged_in

        @movie = Movie.find_by_slug(params[:slug])
        
        if @movie
            erb :'movies/edit'
        else
            flash[:message] = "That movie does not exist."
            erb :'movies/movies'
        end
    end

    post '/movies' do
        redirect_if_not_logged_in
        
        existing_movie = Movie.find_by(title: params[:title])

        if params[:title] == "" || params[:director] == "" || params[:genre] == "" || params[:release_date] == ""
            flash[:message] = "You left some fields blank!"
            redirect to '/movies/new'
        elsif existing_movie
            flash[:message] = "That movie already exists in the database."
            redirect to '/movies'
        else
            @movie = Movie.create(params)

            flash[:message] = "Movie successfully added!"
            redirect to "/movies/#{@movie.slug}"
        end
    end

    patch '/movies/:slug' do
        redirect_if_not_logged_in

        @movie = Movie.find_by_slug(params[:slug])

        if params[:title] == "" || params[:director] == "" || params[:genre] == "" || params[:release_date] == ""
            flash[:message] = "You left some fields blank!"
            redirect to "/movies/#{@movie.slug}/edit"
        end

        @movie.title = params[:title]
        @movie.director = params[:director]
        @movie.genre = params[:genre]
        @movie.release_date = params[:release_date]
        @movie.save

        flash[:message] = "Movie successfully updated!"
        redirect to "/movies/#{@movie.slug}"
    end

    delete '/movies/:slug' do 
        redirect_if_not_logged_in

        @movie = Movie.find_by_slug(params[:slug])

        if !@movie.reviews.empty?
            flash[:message] = "This movie cannot be deleted, as it has existing reviews."
            redirect to "/movies/#{@movie.slug}"
        else
            @movie.destroy
            @movies = Movie.all
            flash[:message] = "Movie successfully deleted!"
            erb :'movies/movies'
        end
    end

end