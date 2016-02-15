namespace :setup do

  desc "Import files and HTML"
  task import_content: :environment do
    Rake::Task["setup:import_files"].invoke
    Rake::Task["setup:import_html"].invoke
    puts "Done. Ready to run."
  end

  desc "Make initial symlinks"
  task make_symlinks: :environment do 
    repos_dir = "#{Rails.root}/repos"
    public_dir = "#{Rails.root}/public"
    @repos = Repo.all
    @projects = Project.all
    
    @repos.each do |repo|
      @projects.each do |p|
        unless File.symlink?("#{public_dir}/#{@repo.name}/source/#{p.name}")
          FileUtils.ln_s("#{repos_dir}/#{@repo.name}/source/#{p.name}", "#{public_dir}/#{@repo.name}/source/")
        end
      end
    end
  end
    
  desc "Import pages for active versions."
  task import_files: :environment do
    Version.active.each do |version|
      puts "Importing files for #{version.project.display_name} #{version.version_number}"
      version.import_files
    end
  end
  
  desc "Import HTML and elements for pages from active versions."
  task import_html: :environment do
    versions = Version.active

    versions.each do |version|
      puts "Importing HTML for #{version.project.display_name} #{version.version_number}"
      pages = version.pages
      progress_length = pages.count
      bar = ProgressBar.new(progress_length)
      version.pages.each do |p|
        begin
          p.elements.destroy_all
          p.content_reimport
          p.element_import
        rescue Exception => e 
          puts "#{p.title}/#{p.filename}: #{e}"
        end
        bar.increment!
      end
    end
  end
  
  desc "Make the tech writers admins."
  task set_admins: :environment do
    system ("rails r scripts/writers2admins.rb")
  end

end
