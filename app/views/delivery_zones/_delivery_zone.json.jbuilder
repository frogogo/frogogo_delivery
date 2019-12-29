json.cache! delivery_zone do
  json.extract! delivery_zone,
                :id, :fee, :free_delivery_gold_threshold,
                :free_delivery_threshold, :zone
end
