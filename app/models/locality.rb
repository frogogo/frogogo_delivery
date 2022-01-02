# == Schema Information
#
# Table name: localities
#
#  id                 :bigint           not null, primary key
#  data               :jsonb
#  latitude           :float
#  locality_uid       :string
#  longitude          :float
#  name               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  delivery_zone_id   :bigint
#  parent_locality_id :bigint
#  subdivision_id     :bigint           not null
#

class Locality < ApplicationRecord
  belongs_to :delivery_zone, optional: true
  belongs_to :subdivision
  belongs_to :parent_locality, class_name: 'Locality', optional: true

  has_many :delivery_methods, as: :deliverable, dependent: :destroy
  has_many :child_localities,
           class_name: 'Locality',
           foreign_key: 'parent_locality_id',
           dependent: :destroy

  validates :name, presence: true

  before_validation :create_subdivision
  before_create :set_delivery_zone

  after_create_commit :set_parent_locality

  def needs_update?
    return true if created_at == updated_at

    updated_at < 1.week.ago
  end

  private

  # пос Электроизолятор, г Раменское -> г Раменское
  def set_parent_locality
    return if data['city_kladr_id'].blank?
    return if data['kladr_id'] == data['city_kladr_id']
    return if Locality.find_by(locality_uid: data['city_kladr_id'])

    suggestion = DaDataService.instance.suggestion_from_locality_uid(data['city_kladr_id'])
    update_attribute(
      :parent_locality,
      Locality.create!(DaDataSuggestion.new(suggestion).locality_attributes)
    )
  end

  def set_delivery_zone
    # Поиск зоны доставки по городу
    locality_zone = I18n.t(
      subdivision.name,
      scope: %i[delivery_zones cities region],
      default: {}
    )[name.to_sym]

    if locality_zone.present?
      self.delivery_zone = DeliveryZone.find_by(zone: locality_zone[:delivery_zone])
    else
      self.delivery_zone = subdivision.delivery_zone
    end
  end

  def create_subdivision
    self.subdivision = Subdivision.find_or_create_by!(name: data['region'])
  end
end
