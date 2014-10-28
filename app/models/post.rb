class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_one :category
end