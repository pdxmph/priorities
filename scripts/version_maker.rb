versions = ["1.2", "2.0", "2.5", "2.6", "2.7", "2.8", "3.0", "3.1", "3.2"]

project = Project.find_by_name("pe")
versions.each do |v|

version = project.versions.new(:version_number => v, 
                               :branch => "master", 
                               :source_repo => "https://github.com/puppetlabs/puppet-docs",
                               :version_directory => "puppet-docs/source/pe/#{v}",
                               :published => true,
                               :active => false)
                               
puts version.inspect
version.save
end