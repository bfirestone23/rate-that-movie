class ReviewsController < ApplicationController

    get '/reviews' do
        erb :'reviews/reviews'
    end

    get '/reviews/new' do
        erb :'reviews/new'
    end
end