namespace :data do
  task reset: :environment do
    Subdivision
      .where('subdivisions.created_at < ?', 3.days.ago)
      .destroy_all
  end
end
