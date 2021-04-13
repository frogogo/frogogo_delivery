namespace :five_post do
  task fetch_points: :environment do
    five_post_points = RU::FivePostAdapter.new

    five_post_points.clear_points
    five_post_points.pickup_point_list
  end
end
