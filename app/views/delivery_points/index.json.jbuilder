json.cache! @delivery_points, expires_in: 10.minutes do
  json.delivery_points do
    if request.headers['Display'] == 'short'
      json.array! @delivery_points, partial: 'delivery_point_short', as: :delivery_point
    else
      json.array! @delivery_points.page(params[:page]), partial: 'delivery_point',
                                                        as: :delivery_point
    end
  end
end

json.partial! 'pagination/links', relation: @delivery_points.page(params[:page])
json.partial! 'pagination/meta', relation: @delivery_points.page(params[:page])
