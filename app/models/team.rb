class Team < ActiveRecord::Base
  belongs_to :user
  has_many :goals
  markdownize! :description

end
