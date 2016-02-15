pages = Page.all

pages.each do |p|
  version = p.url.gsub(/.+?\/pe\/(.+?)\/.*/, "\\1")
  p.version = version
  p.save
end
