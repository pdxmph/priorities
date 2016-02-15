require 'find'

pages = Page.where(:private => true)

pages.each do |p|

  others =  Page.where("filename = ? AND id != ?",p.filename,p.id)
  if others.size > 0
    puts "duplicate found for #{p.filename}"
  end
end

