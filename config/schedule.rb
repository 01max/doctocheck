# frozen_string_literal: true

# every 1.day, at: '21:00' do
#   rake 'doctolib:check_and_summarize'
# end

# every 15.minutes do
#   rake 'doctolib:periodic_check'
# end

every 1.minutes do
  rake 'doctolib:check_and_summarize'
end
