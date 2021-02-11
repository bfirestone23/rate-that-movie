class MoviesController < ApplicationController

    get '/movies' do
        @request
        @movies = Movie.all
        if logged_in?
            erb :'movies/movies'
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            erb :index
        end
    end

    get '/movies/new' do
        if logged_in?
            erb :'movies/new'
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            redirect to '/'
        end
    end

    get '/movies/:slug' do
        if logged_in?
            @movie = Movie.find_by_slug(params[:slug])
            if @movie
                erb :'movies/show'
            else
                flash[:message] = "That movie does not exist."
                erb :'movies/movies'
            end
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            redirect to '/'
        end
    end

    get '/movies/:slug/edit' do
        if logged_in?
            @movie = Movie.find_by_slug(params[:slug])
            if @movie
                erb :'movies/edit'
            else
                flash[:message] = "That movie does not exist."
                erb :'movies/movies'
            end
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            redirect to '/'
        end
    end

    post '/movies' do
        if logged_in?
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
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            redirect to '/'
        end
    end

    patch '/movies/:slug' do
        if logged_in?
            if params[:title] == "" || params[:director] == "" || params[:genre] == "" || params[:release_date] == ""
                @movie = Movie.find_by_slug(params[:slug])

                flash[:message] = "You left some fields blank!"
                redirect to "/movies/#{@movie.slug}/edit"
            elsif Movie.find_by(title: params[:title])
                @movie = Movie.find_by(title: params[:title])

                flash[:message] = "That movie already exists in the database."
                redirect to "/movies/#{@movie.slug}"
            else
                @movie = Movie.find_by_slug(params[:slug])
                @movie.title = params[:title]
                @movie.director = params[:director]
                @movie.genre = params[:genre]
                @movie.release_date = params[:release_date]
                @movie.save

                flash[:message] = "Movie successfully updated!"
                redirect to "/movies/#{@movie.slug}"
            end
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            redirect to '/'
        end
    end

    delete '/movies/:slug' do 
        if logged_in?
            @movie = Movie.find_by_slug(params[:slug])
            if !@movie.reviews.empty?
                flash[:message] = "This movie cannot be deleted, as it has existing reviews."
                redirect to "/movies/#{@movie.slug}"
            else
                @movie.destroy

                flash[:message] = "Movie successfully deleted!"
                erb :'movies/movies'
            end
        else
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            redirect to '/'
        end
    end

end