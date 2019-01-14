# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AppParameter.set_defaults

PracticeArea.create([{ name: 'Bankruptcy', parent_id: nil}, { name: 'Divorce and Family', parent_id: nil}, { name: 'Employment', parent_id: nil}, {name: 'Immigration', parent_id: nil}, { name: 'Pre-Litigation Advice', parent_id: nil}, { name: 'Real Estate / Rentals', parent_id: nil}, { name: 'Startups / Business', parent_id: nil}, { name: 'Tax'}, { name: 'Wills and Trusts', parent_id: nil}])

Offering.create([
  { name: "Contract review" }, 
  { name: "Incorporation" }, 
  { name: "Trademark application" }, 
  { name: "Will and estate creation" }
])

