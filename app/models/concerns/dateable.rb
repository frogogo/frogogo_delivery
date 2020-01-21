module Dateable
  extend ActiveSupport::Concern

  def expires_in
    time_before_delivery_date_changes - Time.current
  end

  def estimate_delivery_date
    return if date_interval.blank?

    calculate_estimate_delivery_date(Date.current)
  end

  private

  def calculate_estimate_delivery_date(date)
    estimate_delivery_date = date
    if (Date.current.friday? || Date.current.on_weekend?) &&
       !I18n.t(:deliverables, scope: %i[constants time_intervals]).include?(deliverable.name)
      estimate_delivery_date = estimate_delivery_date.next_weekday
    end

    estimate_delivery_date += date_interval.scan(/\d+/).last.to_i.days
    estimate_delivery_date += 1.day if Time.current > time_before_delivery_date_changes

    return estimate_delivery_date if estimate_delivery_date.on_weekday?
    return estimate_delivery_date if I18n.t(:deliverables, scope: %i[constants time_intervals]).include?(deliverable.name)

    estimate_delivery_date.next_weekday
  end

  def constant_time_intervals
    if I18n.t(:deliverables, scope: %i[constants time_intervals]).include?(deliverable.name)
      I18n.t(:extended, scope: %i[constants time_intervals])
    else
      I18n.t(:default, scope: %i[constants time_intervals])
    end
  end

  def time_before_delivery_date_changes
    # 16:00
    Time.current.middle_of_day + 4.hours
  end
end
