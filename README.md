# Rate That Movie

A RESTful web application built using Sinatra that allows users to create and share movie reviews.

## Demo

[Click here to view a demo!](https://drive.google.com/file/d/1fOOJc7fgact2PUPse6_cwbQ2ZAVZsv0U/view?usp=sharing) 

[Click here to access the application via Heroku.](https://rate-that-movie.herokuapp.com/)

## Installation

Fork and clone this repository. Then install all dependencies:

```bundle install```

Run the migrations:

```rake db:migrate```

And start up the server:

```shotgun```

You can then navigate to http://localhost:9393 to access the application.

## Usage

Create an account or sign in on the homepage. Then, you can create a new review, or view other users' reviews.

When creating a review, the user is prompted to either select a movie from the database or add a new one. Once a movie has been added to the database, it will be available for other users to select from when creating a review.

A user can edit or delete reviews they've created, but not those of other users. Movies can be updated by any user but not deleted if they are currently being used in a review.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bfirestone23/rate_a_movie.

## License

Released under the terms of the [MIT License](https://opensource.org/licenses/MIT).
