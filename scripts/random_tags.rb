writers = ['isaac', 'larissa', 'michelle', 'nick', 'pete', 'jean', 'jorie']
random_tags = ['puppet', 'pe', 'ssl', 'security', 'classification', 'install', 'qsg', 'hiera', 'facter']


pages = Page.all

pages.each do |p|
  writers_count =  rand(0..2)
  tags_count = rand(0..5)
  p.tag_list.add(writers.sample(writers_count))
  p.tag_list.add(random_tags.sample(tags_count))
  p.save
end
