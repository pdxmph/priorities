project = Project.find_by_name("pe")

project.versions.each do |v|
  el_count = 0
  
  v.pages.each do |p|
    el_count += p.elements.count 
  end
  puts "#{v.version_number}: #{el_count}"
end
  