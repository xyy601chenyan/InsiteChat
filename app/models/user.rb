class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,:authentication_keys => [:login]

  attr_accessor :login
  validates :username,
    :presence => true,
   :uniqueness => {
    :case_sensitive => false
  } 
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  # To aviod using email as user name
    def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    #Note that this is a “shallow” copy as it copies the object's attributes only, not its associations.
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

end
