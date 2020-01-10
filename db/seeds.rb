# Create countries
# slovenia = Country.create!(iso_code: 'SI', language_code: 'sl', name: 'Slovenia')
russia = Country.create!(iso_code: 'RU', language_code: 'ru', name: 'Россия')
turkey = Country.create!(iso_code: 'TR', language_code: 'tr', name: 'Turkey')

# Create delivery_zones
DeliveryZone.create!(fee: 399, free_delivery_gold_threshold: 1500, free_delivery_threshold: 2000, zone: 1, country: russia)
DeliveryZone.create!(fee: 499, free_delivery_gold_threshold: 1500, free_delivery_threshold: 2000, zone: 2, country: russia)
DeliveryZone.create!(fee: 599, free_delivery_gold_threshold: 2000, free_delivery_threshold: 2500, zone: 3, country: russia)
DeliveryZone.create!(fee: 699, free_delivery_gold_threshold: 3000, free_delivery_threshold: 3500, zone: 4, country: russia)
DeliveryZone.create!(fee: 799, free_delivery_gold_threshold: 3500, free_delivery_threshold: 4500, zone: 5, country: russia)
DeliveryZone.create!(fee: 999, free_delivery_gold_threshold: 5000, free_delivery_threshold: 6000, zone: 6, country: russia)
DeliveryZone.create!(fee: 7, free_delivery_gold_threshold: 100, free_delivery_threshold: 150, zone: :default, country: turkey)

# Create subdivisions
# istanbul = Subdivision.create!(iso_code: 'TR-34', local_code: '34', name: 'İstanbul', country: turkey)
# ljubljana = Subdivision.create!(iso_code: 'SI-061', local_code: '61', name: 'Ljubljana', country: slovenia)
tr_default_sub = Subdivision.create!(iso_code: '00', local_code: '00', name: 'Default', country: turkey, delivery_zone: turkey.delivery_zones.default.first)
# moscow = Subdivision.create!(iso_code: 'RU-MOW', local_code: '45', name: 'Москва', country: russia, delivery_zone: russia.delivery_zones.find_by(zone: 1))

# Create localities
# Locality.create!(name: 'İstanbul', local_code: '212', postal_code: '34000', subdivision: tr_default_sub)
# Locality.create!(name: 'Ljubljana', local_code: '3861', postal_code: '1000', subdivision: ljubljana)
# Locality.create!(name: 'Москва', local_code: '45000000', postal_code: '101000', delivery_zone: russia.delivery_zones.find_by(zone: 1), subdivision: moscow)

# Create providers
# Provider.create!(name: 'Russian Post')
Provider.create!(code: 'boxberry', name: 'Boxberry')
Provider.create!(code: 'shop-logistics', name: 'ShopLogistics')
Provider.create!(name: 'Turkey Post')

# Create delivery methods
# DeliveryMethod.create!(method: :post, deliverable: moscow, provider: russian_post)
DeliveryMethod.create!(method: :post, deliverable: tr_default_sub, provider: Provider.find_by(name: 'Turkey Post'))
