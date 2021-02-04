class User < ActiveRecord::Base
    has_secure_password
    has_many :reviews
    has_many :movies, through: :reviews

    def slug
        username.downcase.gsub(" ", "-")
    end

    def self.find_by_slug(slug)
        User.all.find do |u|
            u.slug == slug
        end
    end
end