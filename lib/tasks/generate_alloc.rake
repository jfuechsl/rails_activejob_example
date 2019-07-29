namespace :echo do
  desc "Generate Alloc jobs"
  task :generate => :environment do
    job_count = ENV['ALLOC_JOB_COUNT'].to_i || 100
    puts "Generating #{job_count} jobs..."
    job_count.times{ AllocJob.perform_later }
  end
end
