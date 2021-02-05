class MoviesController < ApplicationController

    get '/movies' do
        if logged_in?
            erb :'movies/movies'
        else
            #Flash msg: You do not have access to this page, please log in or sign up
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
            erb :'movies/show'
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

end