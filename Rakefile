# frozen_string_literal: true

require_relative 'main'

namespace :doctolib do
  task :periodic_check do
    run_checks
  end

  task :check_and_summarize do
    run_checks(force_output: true)
  end
end
