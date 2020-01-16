module Dateable
  extend ActiveSupport::Concern

  def expires_in
    Time.use_zone(time_zone) do
      Time.current.middle_of_day + 4.hours - Time.current
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

    if estimate_delivery_date.on_weekday? || I18n.t(:deliverables, scope: %i[constants time_intervals]).include?(subdivision&.name)
      estimate_delivery_date
    else
      estimate_delivery_date.next_weekday
    end
  end

  def constant_time_intervals
    case I18n.locale
    when :ru
      if I18n.t(:deliverables, scope: %i[constants time_intervals]).include?(deliverable.name)
        I18n.t(:extended, scope: %i[constants time_intervals])
      else
        I18n.t(:default, scope: %i[constants time_intervals])
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
