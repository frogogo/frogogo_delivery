# Create countries
Country.create!(iso_code: 'RU', language_code: 'ru', name: 'Россия')
Country.create!(iso_code: 'SI', language_code: 'sl', name: 'Slovenia')
Country.create!(iso_code: 'TR', language_code: 'tr', name: 'Turkey')

# Create subdivisions
Subdivision.create!(iso_code: 'RU-MOW', local_code: '45', name: 'Москва', country: Country.find_by!(language_code: 'ru'))
Subdivision.create!(iso_code: 'SI-061', local_code: '61', name: 'Ljubljana', country: Country.find_by!(language_code: 'sl'))
Subdivision.create!(iso_code: 'TR-34', local_code: '34', name: 'İstanbul', country: Country.find_by!(language_code: 'tr'))
