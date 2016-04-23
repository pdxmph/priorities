class List < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :user
  has_many :goals
  markdownize! :description
  extend FriendlyId
  friendly_id :name, use: :slugged

  def to_param
    [id, name.parameterize].join("-")
  end
end
