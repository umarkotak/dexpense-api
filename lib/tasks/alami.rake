namespace :alami do
  # bin/rails g task alami start_bot
  desc "bin/rake 'alami:start_bot'"
  task start_bot: :environment do
    Alami::Bot.new.call
  end
end
