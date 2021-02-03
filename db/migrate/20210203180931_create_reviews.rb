class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :movie_id
      t.float :rating
      t.text :description
      t.date :watch_date
    end
  end
end
