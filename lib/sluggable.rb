module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    class_attribute :slug_column
  end

  def generate_slug!
    slug = to_slug(self.send(self.class.slug_column.to_sym))

    # check for multiple slugs
    results = self.class.where( ['slug LIKE ?', "#{slug}%"] ).size
    if results != 0
      if (/-/ =~ slug) == (slug.size - 1)
        slug += (results + 1).to_s
      else
        slug += "-" + (results + 1).to_s
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

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end

end