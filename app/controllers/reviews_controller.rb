class ReviewsController < ApplicationController

    get '/reviews' do
        erb :'reviews/reviews'
    end

    get '/reviews/new' do
        erb :'reviews/new'
    end

    post '/reviews' do
        binding.pry
    end
end