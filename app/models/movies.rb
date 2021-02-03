class Movie < ActiveRecord::Base
    has_many :reviews
    has_many :users, through: :reviews

    def slug
        title.downcase.gsub(" ", "-")
      end
  
    def self.find_by_slug(slug)
        Movie.all.find do |m|
            m.slug == slug
        end
    end
end