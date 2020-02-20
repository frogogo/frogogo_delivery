namespace :data do
  task reset: :environment do
    Subdivision
      .joins(:country)
      .where(countries: { language_code: 'ru' })
      .where('subdivisions.created_at < ?', 3.days.ago)
      .destroy_all
  end
end
