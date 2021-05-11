# frozen_string_literal: true

every 1.day, at: ['12:05', '21:05'] do
  rake 'doctolib:check_and_summarize'
end

every 10.minutes do
  rake 'doctolib:periodic_check'
end
