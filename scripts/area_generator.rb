areas = ["PE Docs (core)",
"PE Quick Start Guide",
"PE Workflows",
"Windows documentation improvements",
"Puppet Install/Configure Docs",
"Puppet Workflows/Howtos",
"Styleguide maintenance",
"Generated references ",
"API documentation ",
"Reference Architectures",
"Marionette Collective",
"PuppetDB",
"PuppetServer",
"Facter",
"Pegasus",
"Cthun",
"Hiera",
"Upstream Release Notes",
"Forge (Website)",
"Forge (READMEs)",
"Knowledgebase Support",
"Development Editing",
"Copy Editing",
"Localization (translations)",
"Localization (tooling)",
"Publisher Support",
"PDF Generation",
"Team Education",
"Customer Success Support "]

areas.each do |a|
  area = Area.new
  area.name = a
  area.save
end
