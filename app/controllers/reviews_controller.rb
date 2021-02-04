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

    post '/reviews' do
        binding.pry
    end
end