page_versions = Hash.new(0)
element_versions = Hash.new(0)

Page.all.each do |p|
  page_versions[p.version] +=1
end

Element.where(:kind => "img").each do |e|
  element_versions[e.page.version] +=1
end

puts "Pages"
page_versions.each { |k,v| puts "#{k}: #{v}"}

puts "Elements"
element_versions.each { |k,v| puts "#{k}: #{v}"}
