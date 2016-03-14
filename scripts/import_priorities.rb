require 'csv'

# This script wants a CSV file with information in the following positions:
# Name of the list the goal belongs to: column 0, list will be created if a list named this isn't found
# Name of the goal: column 1
# Priority of the goal: column 3
# Support for the goal: column 4
# Goal description: concats columns 5 & 9
#
# Yes, this is odd and arbitrary based on something I needed to smash into the database. 

# Use the email address of the user who will own the imported lists
user_email = "mike.hall@puppetlabs.com"

# Nothing user-serviceable below here unless you want to reassign the columns the script gets import data from

user = User.find_by_email(user_email)

csv = File.join(File.dirname(__FILE__), "2017_eng_initiatives.csv")
csv_text = File.read(csv)
csv = CSV.parse(csv_text)
puts csv.count

csv.each do |row|
  list_name = row[0]
  list = List.find_or_create_by(:name => list_name)
  list.user_id = user.id
  list.save
  goal = list.goals.new
  goal.name = row[1]
  goal.priority = row[3]
  goal.support = row[4]
  goal.description = "#{row[5]}: #{row[9]}"
  goal.save
  

end
