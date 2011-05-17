desc 'This task is called by the Heroku cron add-on'
task :cron => [:drop, :import]

