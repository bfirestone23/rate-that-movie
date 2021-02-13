require 'csv'

User.create(username: "Brian", email: "bfirestone2339@gmail.com", password: "test")
User.create(username: "Michael", email: "bfirestone2339@gmail.com", password: "test")
User.create(username: "Jordan", email: "bfirestone2339@gmail.com", password: "test")
User.create(username: "Andrew", email: "bfirestone2339@gmail.com", password: "test")
User.create(username: "Marcus", email: "bfirestone2339@gmail.com", password: "test")


table = CSV.parse(File.read("lib/movies.csv"), headers: true)

table.each do |r|
    movie = Movie.create(title: r["title"], director: r["director"], genre: r["genre"], release_date: r["release date"])

    if movie.title
        movie.director = "n/a" if movie.director == nil
        movie.genre = "n/a" if movie.genre == nil
        movie.release_date = "n/a" if movie.release_date == nil
        movie.save
    else
        movie.delete
    end
end

reviews_table = CSV.parse(File.read("lib/reviews.csv"), headers: true)

reviews_table.each do |r|
    review = Review.create(rating: r[2].to_f, description: r[4], watch_date: r[3])
    review.user = User.find_by(username: r[0])
    review.movie = Movie.find_by(title: r[1])

    if review.movie == nil
        review.delete
    else
        review.save
    end
end