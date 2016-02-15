class User < ActiveRecord::Base
  has_and_belongs_to_many :areas
  acts_as_voter
  acts_as_tagger
  has_many :comments, :dependent => :destroy  
  has_many :teams
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable, :recoverable

  scope :admins, -> {where(:admin => true)}


  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :fullname,
      [:fullname, :id]
    ]
  end
 
 
  def handle
    self.fullname ? self.fullname : self.email
  end
 
end
