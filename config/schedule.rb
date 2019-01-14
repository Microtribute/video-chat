# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "#{path}/log/cron.log"

every 1.hour do
  runner "Inquiry.close_expired"
  # runner "Inquiry.close_expired", environment: "development" # For staging
end

every 1.day, :at => '5am' do
  command "#{path}/bin/backup_database -e production"
end

every 5.minutes do
  rake 'lawyer:update_online_status'
end

every 12.hours do
  rake 'lawyer:update_payment_status'
end

every 1.hours do
  rake 'sunspot:solr:reindex'
end
