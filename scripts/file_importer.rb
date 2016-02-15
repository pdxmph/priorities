require 'find'


projects = Rails.configuration.docs.projects

projects.each do |dir,version_list|
  content_dir = File.expand_path("#{Rails.root}/public/puppet-docs/source/#{dir}", __FILE__)
  project = Project.find_or_create_by(:name => dir)

  Find.find(content_dir) do |f|
    next unless f.match(/\.(markdown|md)\Z/)
    next if f.match(/.+?\/_(.+?)\.(markdown|md)/)
     begin
       version_number = f.match(/^.*\/#{dir}\/(.+?)\//)[1]
       next unless version_list.include?(version_number)
       version = project.versions.find_or_create_by(:version_number => version_number)
     rescue
       version_number = "no version"
       next
     end

    begin
      src_yaml =  YAML.load_file(f)
    rescue
      puts "Problem processing the YAML frontmatter in this file: #{f}"
    end
    
      
    begin
      file_name = f.match(/^.*\/source\/(.+?\.(markdown|md)$)/)[1]
    rescue
       file_name = "borked file name"
       next
    end

    begin
    version.pages.find_or_create_by(:filename => file_name, :title => src_yaml['title'].strip)
    rescue
      puts "Problem with this file: #{f}"
    end
    
  end
end
