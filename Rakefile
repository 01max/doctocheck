# frozen_string_literal: true

require_relative 'main'

namespace :doctolib do
  # Will check for changes in availabilites, return them if any with the current summary
  task :periodic_check do
    run_checks
  end

  # Will return the current summary (even if there are no changes)
  task :check_and_summarize do
    run_checks(force_output: true)
  end
end
