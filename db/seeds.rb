# Create countries
russia = Country.create!(iso_code: 'RU', language_code: 'ru', name: 'Россия')
slovenia = Country.create!(iso_code: 'SI', language_code: 'sl', name: 'Slovenia')
turkey = Country.create!(iso_code: 'TR', language_code: 'tr', name: 'Turkey')

# Create subdivisions
istanbul = Subdivision.create!(iso_code: 'TR-34', local_code: '34', name: 'İstanbul', country: turkey)
ljubljana = Subdivision.create!(iso_code: 'SI-061', local_code: '61', name: 'Ljubljana', country: slovenia)
moscow = Subdivision.create!(iso_code: 'RU-MOW', local_code: '45', name: 'Москва', country: russia)

# Create localities
Locality.create!(name: 'İstanbul', local_code: '212', postal_code: '34000', subdivision: istanbul)
Locality.create!(name: 'Ljubljana', local_code: '3861', postal_code: '1000', subdivision: ljubljana)
Locality.create!(name: 'Москва', local_code: '45000000', postal_code: '101000', subdivision: moscow)

# Create providers
Provider.create!(name: 'Boxberry')
Provider.create!(name: 'Post')
Provider.create!(name: 'ShopLogistics')
