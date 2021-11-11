namespace :five_post do
  task fetch_points: :environment do
    RU::FivePostService.new.fetch_pickup_points
  end
end
