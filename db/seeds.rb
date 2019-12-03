# Create countries
russia = Country.create!(iso_code: 'RU', language_code: 'ru', name: 'Россия')
slovenia = Country.create!(iso_code: 'SI', language_code: 'sl', name: 'Slovenia')
turkey = Country.create!(iso_code: 'TR', language_code: 'tr', name: 'Turkey')

# Create delivery_zones
DeliveryZone.create!(fee: 399, free_delivery_gold_threshold: 1000, free_delivery_threshold: 1500, country: russia)
DeliveryZone.create!(fee: 499, free_delivery_gold_threshold: 1500, free_delivery_threshold: 2000, country: russia)
DeliveryZone.create!(fee: 599, free_delivery_gold_threshold: 2000, free_delivery_threshold: 2500, country: russia)
DeliveryZone.create!(fee: 699, free_delivery_gold_threshold: 2000, free_delivery_threshold: 2500, country: russia)
DeliveryZone.create!(fee: 799, free_delivery_gold_threshold: 3500, free_delivery_threshold: 4500, country: russia)
DeliveryZone.create!(fee: 999, free_delivery_gold_threshold: 3500, free_delivery_threshold: 4500, country: russia)
DeliveryZone.create!(default: true, fee: 7, free_delivery_gold_threshold: 100, free_delivery_threshold: 150, country: turkey)

# Create subdivisions
istanbul = Subdivision.create!(iso_code: 'TR-34', local_code: '34', name: 'İstanbul', country: turkey)
ljubljana = Subdivision.create!(iso_code: 'SI-061', local_code: '61', name: 'Ljubljana', country: slovenia)
moscow = Subdivision.create!(iso_code: 'RU-MOW', local_code: '45', name: 'Москва', delivery_zone: russia.delivery_zones.first, country: russia)

# Create localities
Locality.create!(name: 'İstanbul', local_code: '212', postal_code: '34000', subdivision: istanbul)
Locality.create!(name: 'Ljubljana', local_code: '3861', postal_code: '1000', subdivision: ljubljana)
Locality.create!(name: 'Москва', local_code: '45000000', postal_code: '101000', delivery_zone: russia.delivery_zones.first, subdivision: moscow)

# Create providers
Provider.create!(name: 'Boxberry')
Provider.create!(name: 'Post')
Provider.create!(name: 'ShopLogistics')
