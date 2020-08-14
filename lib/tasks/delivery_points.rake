namespace :delivery_points do
  task create: :environment do
    PATH_TO_CITIES = 'lib/data/cities.csv'

    CSV.foreach(PATH_TO_CITIES) do |locality, subdivision|
      DeliveryMethodsResolver.new(locality: locality, subdivision: subdivision).resolve
    rescue Net::OpenTimeout => e
      Rails.logger.error(e.inspect)
    end
  end
end
