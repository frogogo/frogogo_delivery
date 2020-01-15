module Dateable
  extend ActiveSupport::Concern

  def expires_in
    Time.use_zone(time_zone) do
      Time.current.end_of_day - Time.current
    end
  end

  def estimate_delivery_date
    return if date_interval.blank?

    Time.use_zone(time_zone) do
      calculate_esimate_delivery_date(Date.current)
    end
  end

  private

  def calculate_esimate_delivery_date(date)
    estimate_delivery_date = date + date_interval.scan(/\d+/).last.to_i.days
    # +1 day if Time.current > 4pm
    estimate_delivery_date += 1.day if Time.current > Time.current.middle_of_day + 4.hours

    if estimate_delivery_date.on_weekday? || RU::Constants::CITIES_WITH_EXTENDED_TIME_INTERVALS.include?(subdivision&.name)
      estimate_delivery_date
    else
      estimate_delivery_date.next_weekday
    end
  end

  def constant_time_intervals
    case I18n.locale
    when :ru
      if RU::Constants::CITIES_WITH_EXTENDED_TIME_INTERVALS.include?(self.deliverable.name)
        RU::Constants::EXTENDED_TIME_INTERVALS
      else
        RU::Constants::TIME_INTERVALS
      end
    end
  end

  def time_zone
    @time_zone ||=
      case I18n.locale
      when :ru then 'Moscow'
      when :sl then 'Ljubljana'
      when :tr then 'Istanbul'
      end
  end
end
