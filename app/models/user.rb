class User
  include Mongoid::Document
  field :email
  field :password
end
