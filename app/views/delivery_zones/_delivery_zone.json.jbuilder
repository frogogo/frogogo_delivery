json.cache! delivery_zone do
  json.extract! delivery_zone,
                :courier_fee, :fee, :pickup_fee, :post_fee,
                :free_delivery_gold_threshold,
                :free_delivery_threshold
end
