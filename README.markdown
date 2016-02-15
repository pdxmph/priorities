# Docs Decomposer

The Docs Decomposer is an inventory tool for documentation at Puppet
Labs. With it, you can:

- Import the pages and content from a given Puppet Labs project or
upstream.
- Flag, comment on, tag, and assign risk/priority to each page
- Review each page with the option to quickly reveal only: 
  - Heading structure (h-tags)
  - Code and command line examples/steps (pre/code elements)
  - Procedures (ordered, unordered lists)
  - Screenshots (images)

It supports multiple users, each of which can leave comments or set
flags under their own identity. Users designated as an "admin" can set
the risk or priority of a page and also add/remove tags.

## Setup

### Clone puppetlabs/puppet-docs and puppetlabs/puppet-docs-private repos

The tool depends on the puppetlabs/puppet-docs and
puppetlabs/puppet-docs-private repos to import content into its database:

`cd repos`  
`git clone git@github.com:puppetlabs/puppet-docs-private.git`  
`git clone git@github.com:puppetlabs/puppet-docs.git`  

### Install the Gems

`# bundle install --path vendor/bundle`

### Configure the import tools

The `config/application.rb` file contains settings that drive which
content is imported into the tool:

The `docs.projects` setting uses the directory name and version
numbers of projects as found in the docs repo to drive which projects
and versions are captured:

`config.docs.projects = {'pe' => ['3.7','3.3'], 'puppet' => ['3.7', '4.0']}`

The `docs.dev_project` setting sets which directory in the private
repo is being used to do work on the next release. In the case of
Puppet Enterprise 3.8, that's PE 3.7. 

`config.docs.dev_project = {'pe' => '3.7'}`

> __Note:__ If the docs workflow ever changes to creating the new
> release under its own version name/number, the release number value
> will need to change to reflect the directory the work is being done in.

The `config.docs.dev_project_number` setting sets how the tool will
report the version number of the development release:

`config.docs.dev_project_number = "3.8-dev"`

### Create the database, perform migrations

To create the database and establish the initial tables:

`# bundle exec RAILS_ENV=production rake db:migrate`

### Import content from the private repo

Use the `scripts/dev_file_importer.rb` script to import content from
the private repo.

`# bundle exec RAILS_ENV=production rails r scripts/dev_file_importer.rb`

> __Note:__ This is clunky and needs to be fixed. This is how it works
> for now.

### Run the setup rake tasks

The tool has a few rake tasks to help with setup once the app is
cloned and you've run `rake db:migrate`. The `setup:import_content`
task will handle refreshing the two docs repos, moving the correct
content into place, and importing HTML from either live or preview
servers. 

`# bundle exec RAILS_ENV=production  rake setup:import_content`

### Start the app

The tool uses the `unicorn-rails` gem to make sure Rails is using
Unicorn. All that's required to get it running is:

`# bundle exec RAILS_ENV=production rake assets:precompile`  
`# bundle exec rails s -e production -d`

## Use

Visit the app's `/docs` URL for a manual on usage.
