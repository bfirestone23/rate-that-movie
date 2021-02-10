require './config/environment'

use Rack::MethodOverride
use MoviesController
use ReviewsController
use UsersController
run ApplicationController