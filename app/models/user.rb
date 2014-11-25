class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  sluggable_column :username

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6))   
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    account_sid = 'ACcceaf0d7acf84c8ca7b330bcfab65281' 
    auth_token = '759510a8aad6f0f24eec4aeee78dcb7a' 
     
    # set up a client to talk to the Twilio REST API 
    client = Twilio::REST::Client.new account_sid, auth_token 
    msg = "Hi, please input the pin to continue login: #{self.pin}" 
    client.account.messages.create({
      :from => '+13157045095', :to => self.phone, :body => msg
    })
  end

  def admin?
    self.role == "admin"  
  end

  def moderator?
    self.role == "moderator"
  end

end