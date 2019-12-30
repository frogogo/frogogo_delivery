module Dateable
  extend ActiveSupport::Concern

  def estimate_delivery_date
    return if date_interval.blank?

    # Only for frogogo.ru
    Time.use_zone('Moscow') do
      @estimate_delivery_date = Date.current + date_interval.last.to_i.days
      # +1 day if Time.current > 4pm
      @estimate_delivery_date += 1.day if Time.current > Time.current.middle_of_day + 4.hours
      if @estimate_delivery_date.on_weekday?
        @estimate_delivery_date = @estimate_delivery_date.next_weekday
      end
    end

    @estimate_delivery_date
  end
end
