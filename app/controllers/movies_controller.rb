class MoviesController < ApplicationController

    get '/movies' do
        erb :'movies/movies'
    end

    get '/movies/:slug' do
        @movie = Movie.find_by_slug(params[:slug])
        erb :'movies/show'
    end

end