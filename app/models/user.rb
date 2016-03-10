class User < ActiveRecord::Base
  has_and_belongs_to_many :lists
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :lists
  has_many :goals, through: :lists

  def full_name
    if self.first_name && self.last_name
      return "#{self.first_name} #{self.last_name}"
    else
      return email
    end
  end

  scope :all_except, ->(user) { where.not(id: user) }

  
  def other_lists
    other_lists = List.includes(:users).where('users.id' => self.id).where.not('user_id' =>  self.id)
    return other_lists
  end

  
end
