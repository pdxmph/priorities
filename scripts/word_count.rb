project = Project.find_by_name("pe")

project.versions.each do |v|
  version_word_count = 0
  v.pages.each do |p|
    version_word_count += WordsCounted.count(p.markdown_content).word_count
  end
  
  puts "#{v.version_number}: #{version_word_count}"
end