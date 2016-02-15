# Use this to migrate metadata from one version of a project to another
# This is generally to prime a new version with existing priority and risk
# information. 

# pe, puppet, etc. 
project_name = "puppet"

# the version you're migrating from
live = "3.7"

# the version you're migrating data to
dev = "3.8"

# Begin non-user-serviceable parts

project = Project.find_by_name(project_name)
live_version = project.versions.find_by_version_number(live)
dev_version = project.versions.find_by_version_number(dev)

progress_length = live_version.pages.count
bar = ProgressBar.new(progress_length)

live_version.pages.each do |page|


  basename = File.basename(page.filename)
  
  begin 
    if  private_page = dev_version.pages.where("filename LIKE ?", "%#{basename}").first
     private_page.risk = page.risk
     private_page.priority = page.priority
     private_page.tag_list.add(page.tag_list)
     private_page.user_id = page.user_id
     private_page.save
    else
      next
    end
  rescue Exception => e
    puts e
  end

  if page.comments.size > 0
    page.comments.each do |old_comment|
      new_comment = old_comment.dup
      new_comment.page_id = private_page.id
      new_comment.save
    end
  end
  bar.increment!
end
