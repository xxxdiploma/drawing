namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:surname => "Example",
                 :initials => "UR",
                 :email => "user@example.org",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    99.times do |n|
      surname  = Faker::Name.last_name
      initials = "UR"
      email = "user-#{n+1}@example.org"
      password  = "password"
      User.create!(:surname => surname,
                   :initials => initials,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end
