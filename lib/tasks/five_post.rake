namespace :five_post do
  task fetch_points: :environment do
    DeliveryPoint.joins(:provider).where(providers: { name: 'FivePost' }).destroy_all

    RU::FivePostService.new.fetch_pickup_points
  end
end
