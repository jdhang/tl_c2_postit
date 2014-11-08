class Post < ActiveRecord::Base
  include Voteable
  include Sluggable

  belongs_to :user
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories


  validates :title, presence: true, length: { minimum: 5 }
  validates :url, presence: true
  validates :description, presence: true
  validates :category_ids, presence: { message: " must be selected"}

  sluggable_column :title

end