namespace :app_initializer do
  desc "Prepare Application on Boot Up"
  task setup: :environment do
    puts "\n== Preparing Elasticsearch =="
    Rake::Task["search:setup"].execute

    puts "\n== Preparing database =="
    begin
      Rake::Task["db:migrate"].execute
    rescue ActiveRecord::NoDatabaseError
      puts "\n== Creating and Seeding database =="
      system("bin/rails db:setup")
    end

    puts "\n== Updating Data =="
    Rake::Task["data_updates:enqueue_data_update_worker"].execute
  end
end
