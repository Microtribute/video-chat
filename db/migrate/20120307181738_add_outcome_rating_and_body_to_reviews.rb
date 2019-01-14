class AddOutcomeRatingAndBodyToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :purpose, :string
    add_column :reviews, :rating, :integer
    add_column :reviews, :body, :text
    remove_column :reviews, :content
  end
end
