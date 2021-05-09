# frozen_string_literal: true

require_relative 'main'

namespace :doctolib do
  task :periodic_check do
    run_check
  end

  task :check_and_summarize do
    run_check(force_output: true)
  end
end
