require './config/environment'

use Rack::MethodOverride
use MoviesController
use ReviewsController
use UsersController
use ApplicationController
run Sinatra::Application 