require 'rack-flash'

class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    use Rack::Flash
    
    configure do
        enable :sessions
        set :session_secret, "my_application_secret"
        set :views, Proc.new { File.join(root, "../views/") }
        set :static, true
    end

    helpers do
        def logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find(session[:user_id])
        end
    end

    not_found do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            flash[:message] = "That page does not exist."
            redirect to "/welcome/#{@user.slug}"
        end
        redirect to "/"
    end
    
    get '/' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            redirect to "/welcome/#{@user.slug}"
        end
        erb :index
    end

    private

    def redirect_if_not_logged_in
        if !logged_in?
            flash[:message] = "You do not have access to that page! Please log in or sign up below."
            redirect to '/'
        end
    end

end