class MoviesController < ApplicationController

    get '/movies' do
        erb :movies
    end

end