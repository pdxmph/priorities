glossary_words = ["attribute", "agent", "catalog", "class", "classify", "declare", "define", "define", "define", "defined resource type", "ENC", "environment", "expression", "external node classifier", "fact", "Facter", "filebucket", "function", "global scope", "host", "host", "idempotent", "inheritance", "inheritance", "master", "manifest", "metaparameter", "module", "namevar", "node", "node scope", "noop", "notify", "notification", "ordering", "parameter", "parameter", "parameter", "parameter", "pattern", "plusignment operator", "property", "provider", "plugin", "realize", "refresh", "relationship", "resource", "resource declaration", "scope", "site", "site manifest", "site module", "subclass", "subscribe", "template", "title", "top scope", "type", "type", "type", "variable", "variable scoping", "virtual resource"]

pages = Project.find_by_name("pe").pages
word_table = Hash.new(0)

progress_length = pages.count
bar = ProgressBar.new(progress_length)

pages.each do |p|
  next if p.version.version_number != "3.7"
  html = Nokogiri::HTML(p.content)
  elements = ["ol","pre","img","ul","code"]
  elements.each do |e|
    html.xpath("//#{e}").remove
end

 text = html.text

 ots_content = OTS.parse(text)
 
 topics  = ots_content.topics
 keywords = ots_content.topics
 
 keywords.each do |word|
   word_table[word] +=1
 end
 
 bar.increment!
end

Hash[word_table.sort_by{|k, v| v}.reverse].each do |k,v|
  next if v < 3
  pair =  "#{k}: #{v}"
  if glossary_words.include?(k)
    pair += " (in glossary)"
  end

  puts pair
end 
