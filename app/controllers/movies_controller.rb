class MoviesController < ApplicationController

    get '/movies' do
        @request
        if logged_in?
            erb :'movies/movies'
        else
            flash[:message] = "You do not have access to this page! Please log in or sign up below."
            redirect to '/'
        end
    end

    get '/movies/new' do
        if logged_in?
            erb :'movies/new'
        else
            #Flash msg: You do not have access to this page, please log in or sign up
            redirect to '/'
        end
    end

    get '/movies/:slug' do
        if logged_in?
            @movie = Movie.find_by_slug(params[:slug])
            if @movie
                erb :'movies/show'
            else
                #Flash msg: Movie does not exist
                erb :'movies/movies'
            end
        else
            #Flash msg: You do not have access to this page, please log in or sign up
            redirect to '/'
        end
    end

    get '/movies/:slug/edit' do
        if logged_in?
            @movie = Movie.find_by_slug(params[:slug])
            erb :'movies/edit'
        else
            #Flash msg: You do not have access to this page, please log in or sign up
            redirect to '/'
        end
    end

    post '/movies' do
        existing_movie = Movie.find_by(title: params[:title])
        if params[:title] == "" || params[:director] == "" || params[:genre] == "" || params[:release_date] == ""
            #Flash msg: Fields left blank - please try again.
            redirect to '/movies/new'
        elsif existing_movie
            #Flash msg: Movie already exists in the database.
            redirect to '/movies'
        else
            @movie = Movie.create(params)
            #Flash msg: Movie successfully created
            redirect to "/movies/#{@movie.slug}"
        end
    end

    patch '/movies/:slug' do
        if params[:title] == "" || params[:director] == "" || params[:genre] == "" || params[:release_date] == ""
            #Flash msg: Fields left blank - please try again.
            @movie = Movie.find_by_slug(params[:slug])
            redirect to "/movies/#{@movie.slug}/edit"
        elsif Movie.find_by(title: params[:title])
            #Flash msg: Movie already exists in the database.
            @movie = Movie.find_by(title: params[:title])
            redirect to "/movies/#{@movie.slug}"
        else
            @movie = Movie.find_by_slug(params[:slug])
            @movie.title = params[:title]
            @movie.director = params[:director]
            @movie.genre = params[:genre]
            @movie.release_date = params[:release_date]
            @movie.save
            #Flash msg: Movie successfully updated
            redirect to "/movies/#{@movie.slug}"
        end
    end

    delete '/movies/:slug' do 
        if logged_in?
            @movie = Movie.find_by_slug(params[:slug])
            if !@movie.reviews.empty?
                #Flash msg: Movie has existing reviews, cannot delete
                redirect to "/movies/#{@movie.slug}"
            else
                @movie.destroy
                #Flash msg: movie successfully deleted
                erb :'movies/movies'
            end
        else
            #Flash msg: You do not have access to this action, please log in or sign up
            redirect to '/'
        end
    end

end