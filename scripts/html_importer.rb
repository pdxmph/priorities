require 'open-uri'
pages = Page.all
 progress_length = pages.count
 bar = ProgressBar.new(progress_length)

pages.each do |p|
  if p.private?
    repo_dir = "puppet-docs-private"
  else
    repo_dir = "puppet-docs"
  end

  images_path = p.filename.gsub(/(^.*\/)\w{1,}\.(md|markdown)/, "/#{repo_dir}/source/\\1")

  begin
    doc = Nokogiri::HTML(open(p.live_url))
    doc_content = doc.xpath("//div[@id='rendered-markdown']")
    doc_content.xpath("//img").each do |i|
      if i[:src].match(/^\.\/images\//)
        i[:src] =  i[:src].gsub(/^\.\/images\//, "#{images_path}images/")
      end
    end
    p.content = doc_content.inner_html
    p.save

  rescue Exception => e  
    puts "something went wrong getting HTML for #{p.title} -- #{e}"
  end
    bar.increment!
end
  
