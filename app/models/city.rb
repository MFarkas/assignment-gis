class City < ActiveRecord::Base
  has_one :country
end
