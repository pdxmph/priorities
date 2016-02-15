tech_writers = {"Isaac Eldridge" => "isaac.eldridge@puppetlabs.com",
                "Jorie Tappa" => "jorie@puppetlabs.com",
                "Mike Hall" => "mike.hall@puppetlabs.com",
                "Larissa Lane" => "larissa@puppetlabs.com",
                "Jean Bond" => "jean@puppetlabs.com",
                "Michelle Fredette" => "michelle.fredette@puppetlabs.com",
                "Pete Soloway" => "pete@puppetlabs.com",
                "Nick Fagerlund" => "nick.fagerlund@puppetlabs.com"}

tech_writers.each do |name, email|
  user = User.find_by(:email => email)
  user.admin = false
  user.save
end
                
