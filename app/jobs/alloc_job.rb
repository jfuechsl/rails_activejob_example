require 'distribution'

class AllocJob < ApplicationJob
  queue_as :default

  def perform(*args)
    count_mean = 100
    count_lambda = count_mean**-1
    count_rng = Distribution::Exponential.rng(count_lambda)
    alloc_count = [1, count_rng.call].max
    alloc_mean = 1024
    alloc_lambda = alloc_mean**-1
    alloc_rng = Distribution::Exponential.rng(alloc_lambda)
    total_bytes = 0
    alloc_count.times do
      alloc_bytes = [[50, alloc_rng.call].max, 1024**2].min
      random_mem = Random.new.bytes(alloc_bytes)
      total_bytes += alloc_bytes
    end
    `echo "ALLOC JOB: #{self.object_id} | #{Time.now}:: #{alloc_count} allocations of a total of #{total_bytes / (1024**2)}MB" >> #{File.join(Rails.root, 'tmp', 'alloc.output')}`
  end
end
