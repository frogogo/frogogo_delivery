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
      @estimate_delivery_date = Date.current + date_interval.last.to_i.days
      # +1 day if Time.current > 4pm
      @estimate_delivery_date += 1.day if Time.current > Time.current.middle_of_day + 4.hours
      if @estimate_delivery_date.on_weekend?
        @estimate_delivery_date = @estimate_delivery_date.next_weekday
      end
    end

    @estimate_delivery_date
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
