class ApplicationController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    
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
    
    get '/' do
        if logged_in?
            @user = User.find_by_id(session[:user_id])
            redirect to "/welcome/#{@user.slug}"
        else
            erb :index
        end
    end

end