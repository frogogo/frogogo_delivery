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
  courier_fee: 7, pickup_fee: 7, post_fee: 7,
  free_delivery_gold_threshold: 100, free_delivery_threshold: 150,
  zone: :default
)

# Create subdivisions
# istanbul = Subdivision.create!(iso_code: 'TR-34', local_code: '34', name: 'İstanbul')
# ljubljana = Subdivision.create!(iso_code: 'SI-061', local_code: '61', name: 'Ljubljana')
# tr_default_sub = Subdivision.create!(iso_code: '00', local_code: '00', name: 'Default', delivery_zone: turkey.delivery_zones.default.first)
# moscow = Subdivision.create!(iso_code: 'RU-MOW', local_code: '45', name: 'Москва', delivery_zone: russia.delivery_zones.find_by(zone: 1))

# Create localities
# Locality.create!(name: 'İstanbul', local_code: '212', postal_code: '34000', subdivision: tr_default_sub)
# Locality.create!(name: 'Ljubljana', local_code: '3861', postal_code: '1000', subdivision: ljubljana)
# Locality.create!(name: 'Москва', local_code: '45000000', postal_code: '101000', delivery_zone: russia.delivery_zones.find_by(zone: 1), subdivision: moscow)

# Create providers
Provider.create!(code: 'russian_post', name: 'RussianPostPickup')
Provider.create!(code: 'boxberry', name: 'Boxberry')
# Provider.create!(name: 'Turkey Post')

# Create delivery methods
DeliveryMethod.create!(method: :post, deliverable: moscow, provider: russian_post)
# DeliveryMethod.create!(
#   method: :post, deliverable: tr_default_sub, provider: Provider.find_by(name: 'Turkey Post')
# )
