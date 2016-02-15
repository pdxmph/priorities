require 'find'

project_name = 'pe'
review_version = Rails.configuration.docs.dev_project[project_name]
review_version_number = Rails.configuration.docs.dev_project_number
content_dir = File.expand_path("#{Rails.root}/repos/puppet-docs-private/source/#{project_name}/#{review_version}", __FILE__)
project = Project.find_or_create_by(:name => project_name)
version = project.versions.find_or_create_by(:version_number => review_version_number)

  Find.find(content_dir) do |f|
    next unless f.match(/\.(markdown|md)\Z/)
    begin
      src_yaml =  YAML.load_file(f)
    rescue
      puts "Problem processing the YAML frontmatter in this file: #{f}"
      next
    end
          
    begin
      file_name = f.match(/^.*\/source\/(.+?\.(markdown|md)$)/)[1]
    rescue Exception => e
       puts e
       file_name = "borked file name"
       next
    end

    begin
    version.pages.find_or_create_by(:filename => file_name, :title => src_yaml['title'].strip, :private => true)
    rescue Exception => e  
      puts "Problem with this file: #{f}"
      puts e
    end
end
