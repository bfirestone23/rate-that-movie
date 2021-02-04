class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    
    configure do
        enable :sessions
        set :session_secret, "my_application_secret"
        set :views, Proc.new { File.join(root, "../views/") }
    end

    helpers do
        def logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find(session[:user_id])
        end
    end
    
    get '/' do
        erb :index
    end

end