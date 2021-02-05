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

    post '/movies' do
        binding.pry
    end

end