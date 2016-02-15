pages = Page.all

writers = ['isaac', 'larissa', 'michelle', 'nick', 'pete', 'jean', 'jorie']

pages.each do |p|
  writer_list = []
  p.tag_list.each do |t|
    if writers.include?(t)
      writer_list << t
    end
  end
  if writer_list.count == 1
    writer_tag = writer_list[0]
  else
    next
  end

  writer = User.where("email LIKE :prefix", prefix: "#{writer_tag}%").first
  puts "#{writer_tag}: #{writer.fullname}"
  p.user_id = writer.id
  p.save
end
