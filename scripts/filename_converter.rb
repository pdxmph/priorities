version = Version.find()
pages = version.pages

pages.each do |p|

  puts p.filename
#  newfilename = p.filename.sub(/puppet\/4.0\/reference\//, "/reference/")
  puts newfilename
  p.filename = newfilename
  p.save
end

#  newfilename = p.filename.sub(/pe\/3.8\//, "/source/")
#  newfilename = p.filename.sub(/puppet\/4.0\/reference\//, "/reference/")
