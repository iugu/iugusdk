require 'database_cleaner'

namespace :db do
  desc 'truncate database data'
  task :truncate => :environment do
    DatabaseCleaner.clean_with :truncation
  end
end
