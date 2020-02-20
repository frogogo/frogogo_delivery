module Dateable
  extend ActiveSupport::Concern

  DIGIT_REGEXP = /\d+/

  def estimate_delivery_date
    estimated_delivery_date
  end

  def estimated_delivery_date
    return if date_interval.blank?

    calculate_estimated_delivery_date(Date.current)
  end

  def expires_in
    time_after_delivery_date_will_change - Time.current
  end

  private

  def calculate_estimated_delivery_date(date)
    delivery_date = date
    delivery_date += 1.day if Time.current > time_after_delivery_date_will_change

    date_interval.scan(DIGIT_REGEXP).last.to_i.times do
      if delivery_date.friday?
        if [6, 7].include?(I18n.t(:avaliable_days_for_delivery, scope: %i[constants])[deliverable_name])
          delivery_date += 1.day
        else
          delivery_date = delivery_date.next_weekday
        end
      elsif delivery_date.saturday?
        if I18n.t(:avaliable_days_for_delivery, scope: %i[constants])[deliverable_name] == 7
          delivery_date += 1.day
        else
          delivery_date = delivery_date.next_weekday
        end
      else
        delivery_date += 1.day
      end
    end

    delivery_date
  end

  def deliverable_name
    case deliverable.class.name
    when 'Locality'
      deliverable.subdivision.name.to_sym
    when 'Subdivision'
      deliverable.name.to_sym
    end
  end

  def default_time_intervals(date)
    if I18n.t(:avaliable_days_for_delivery, scope: %i[constants]).keys.include?(deliverable_name)
      I18n.t("extended.#{Date::DAYS_INTO_WEEK.invert[date.wday]}", scope: %i[constants time_intervals])
    else
      I18n.t(:default, scope: %i[constants time_intervals])
    end
  end

  def time_after_delivery_date_will_change
    Time.current.middle_of_day + 4.hours # 16:00
  end
end
