# Create delivery_zones
DeliveryZone.create!(
  courier_fee: 299, pickup_fee: 199,
  free_delivery_gold_threshold: 1500, free_delivery_threshold: 2000,
  zone: 1
)
DeliveryZone.create!(
  courier_fee: 349, pickup_fee: 249,
  free_delivery_gold_threshold: 1500, free_delivery_threshold: 2000,
  zone: 2
)
DeliveryZone.create!(
  courier_fee: 399, pickup_fee: 299,
  free_delivery_gold_threshold: 2000, free_delivery_threshold: 2500,
  zone: 3
)
DeliveryZone.create!(
  courier_fee: 499, pickup_fee: 399,
  free_delivery_gold_threshold: 2000, free_delivery_threshold: 2500,
  zone: 4
)
DeliveryZone.create!(
  courier_fee: 799, pickup_fee: 699,
  free_delivery_gold_threshold: 4000, free_delivery_threshold: 4500,
  zone: 5
)
DeliveryZone.create!(
  courier_fee: 899, pickup_fee: 799,
  free_delivery_gold_threshold: 5000, free_delivery_threshold: 5500,
  zone: 6
)
DeliveryZone.create!(
  courier_fee: 999, pickup_fee: 899,
  free_delivery_gold_threshold: 6000, free_delivery_threshold: 6500,
  zone: 7
)
DeliveryZone.create!(
  courier_fee: 7, pickup_fee: 7, post_fee: 7,
  free_delivery_gold_threshold: 100, free_delivery_threshold: 150,
  zone: :default
)

# Create subdivisions
# istanbul = Subdivision.create!(name: 'İstanbul')

moscow = Subdivision.create!(
  name: 'Москва',
  delivery_zone: DeliveryZone.find_by(zone: 1)
)

# Create localities
# Locality.create!(name: 'İstanbul', postal_code: '34000', subdivision: tr_default_sub)
# Locality.create!(name: 'Ljubljana', postal_code: '1000', subdivision: ljubljana)
# Locality.create!(
#   name: 'Москва',
#   postal_code: '101000',
#   delivery_zone: DeliveryZone.find_by(zone: 1),
#   subdivision: moscow
# )

dadata = DaDataService.instance
dadata_suggestion = DaDataSuggestion.new(dadata.suggestion_from_locality_uid('7700000000000'))
Locality.create!(dadata_suggestion.locality_attributes)

# Create providers
Provider.create!(code: 'russian_post', name: 'RussianPostPickup')
Provider.create!(code: 'boxberry', name: 'Boxberry')
Provider.create!(code: 'five_post', name: 'FivePost')
# Provider.create!(name: 'Turkey Post')

# Create delivery methods
DeliveryMethod.create!(method: :pickup, deliverable: moscow)
DeliveryMethod.create!(method: :courier, deliverable: moscow)
