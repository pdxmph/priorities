Element.delete_all
pages = Page.all
progress_length = pages.count
bar = ProgressBar.new(progress_length)


# xpath for all headings
# /html/body/*[self::h1 or self::h2 or self::h3]/text()


elements = ["ol","pre","img", "ul"]

pages.each do |p|

  html = Nokogiri::HTML(p.content)

  elements.each do |e|

    html.xpath("//#{e}").each do |h|
      hash = Digest::MD5.hexdigest(h)
      element = Element.new
      element.checksum = hash
      element.content = h
      element_head = h.xpath("preceding::*[name()='h1' or name()='h2' or name()='h3' or name()='h4' or name()='h5']")
      
      unless element_head.last.nil?
        element.nearest_heading = element_head.last.inner_text
      else
        element.nearest_heading = "#{p.title} (page title)"
      end

#      puts element.nearest_heading

      element.page_id = p.id
      element.filename = p.filename
      element.kind = e
      element.save
    end
  end
  bar.increment!
end


