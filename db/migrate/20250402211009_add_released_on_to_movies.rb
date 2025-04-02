class AddReleasedOnToMovies < ActiveRecord::Migration[8.0]
  def change
    add_column :movies, :released_on, :date
  end
end
