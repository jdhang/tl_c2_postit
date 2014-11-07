class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :votes, as: :voteable

  validates :title, presence: true, length: { minimum: 5 }
  validates :url, presence: true
  validates :description, presence: true
  validates :category_ids, presence: { message: " must be selected"}

  before_save :generate_slug!

  def total_votes
    up_votes - down_votes    
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end

  def generate_slug!
    slug = to_slug(self.title)
    # check for multiple slugs
    results = Post.where( ['slug LIKE ?', "#{slug}%"] ).size
    if results != 0
      if (/-/ =~ slug) == (slug.size - 1)
        slug = slug + (results + 1).to_s
      else
        slug = slug + "-" + (results + 1).to_s
      end
    end

    self.slug = slug
  end

  def to_slug(name)
    str = name.strip
    str.gsub! /\s*[^A-Za-z0-9]\s*/, '-'
    str.gsub! /-+/, '-'
    str.downcase
  end

  def to_param
    self.slug
  end
end