class Comment < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  markdownize! :content

  has_one :version, :through =>  :page

end
