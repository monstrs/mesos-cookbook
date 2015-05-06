Signal.trap('INT') { exit 1 }

require 'thread'
require 'kitchen'
require 'rspec'
require 'rspec/wait'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError => e
  raise e
end

@config = Kitchen::Config.new

task :test do
  begin
    run_action(:converge, @config.instances)

    # wait nodes syncronization
    sleep 120

    @config.instances.each(&:verify)
    Rake::Task['spec'].invoke
  rescue => e
    @config.instances.each(&:destroy)
    raise e
  ensure
    @config.instances.each(&:destroy)
  end
end

def run_action(action, instances, *args) # rubocop:disable Metrics/MethodLength
  concurrency = @config.instances.size
  queue = Queue.new

  instances.each { |i| queue << i }
  concurrency.times { queue << nil }

  threads = []
  concurrency.times do
    threads << Thread.new do
      while instance = queue.pop # rubocop:disable Lint/AssignmentInCondition
        instance.public_send(action, *args)
      end
    end
  end
  threads.map(&:join)
end
