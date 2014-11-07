class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true

  before_save :generate_slug!

  def generate_slug!
    slug = to_slug(self.name)
    # check for multiple slugs
    results = Category.where( ['slug LIKE ?', "#{slug}%"] ).size
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
    str.downcase!
    str
  end

  def to_param
    self.slug
  end
end