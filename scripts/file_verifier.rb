require 'find'

file_list = []

content_dir = File.expand_path("#{Rails.root}/repos/puppet-docs-private/source/pe/3.7", __FILE__)

  Find.find(content_dir) do |f|
    next unless f.match(/\.(markdown|md)\Z/)
    next if f.match(/.+?\/_(.+?)\.(markdown|md)/)
    file_list << f.gsub(/^.+?\/source\//,"")
  end  

pages = Page.where(:private => true)

pages.each do |p|
  unless file_list.include?(p.filename)
    puts "*** #{p.filename} isn't in the filesystem"
  else
    puts "Found #{p.filename}."
  end
end

