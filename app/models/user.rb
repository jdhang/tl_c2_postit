class User < ActiveRecord::Base
  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  before_save :generate_slug!

  def generate_slug!
    slug = to_slug(self.username)
    # check for multiple slugs
    results = User.where( ['slug LIKE ?', "#{slug}%"] ).size
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