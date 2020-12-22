module Dateable
  extend ActiveSupport::Concern

  DIGIT_REGEXP = /\d+/
  HOLIDAYS = %w[20210101 20210102 20210103 20210107]

  def date_interval
    case provider.name
    when 'Boxberry'
      self[:date_interval].scan(DIGIT_REGEXP).max
    when 'RussianPostPickup'
      self[:date_interval]
    end
  end

  def estimate_delivery_date
    estimated_delivery_date
  end

  def estimated_delivery_date
    return if date_interval.blank? || provider.name == 'RussianPostPickup'

    calculate_estimated_delivery_date(Date.current)
  end

  def expires_in
    time_after_delivery_date_will_change - Time.current
  end

  private

  def calculate_estimated_delivery_date(date)
    delivery_date = date
    delivery_date += 1.day if Time.current > time_after_delivery_date_will_change

    days_count = date_interval.to_i

    # HACK: add +1 day to delivery interval
    days_count += 1 if override_days_count?

    days_count.times do
      if delivery_date.friday?
        if [6, 7].include?(I18n.t(:avaliable_days_for_delivery)[deliverable_name])
          delivery_date += 1.day
        else
          delivery_date = delivery_date.next_weekday
        end
      elsif delivery_date.saturday?
        if I18n.t(:avaliable_days_for_delivery)[deliverable_name] == 7
          delivery_date += 1.day
        else
          delivery_date = delivery_date.next_weekday
        end
      else
        delivery_date += 1.day
      end
    end

    # TODO: Remove after holidays end
    if delivery_date == HOLIDAYS[0].to_date
      delivery_date += 3.days
    elsif delivery_date == HOLIDAYS[1].to_date
      delivery_date += 2.days
    elsif delivery_date == HOLIDAYS[2].to_date
      delivery_date += 1.day
    elsif delivery_date == HOLIDAYS[3].to_date
      delivery_date += 1.day
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
    if I18n.t(:avaliable_days_for_delivery).keys.include?(deliverable_name)
      I18n.t("#{deliverable_name}.#{Date::DAYS_INTO_WEEK.invert[date.wday]}", scope: %i[time_intervals])
    else
      I18n.t(:default, scope: %i[time_intervals])
    end
  end

  def override_days_count?
    return if deliverable_name == (:Москва || :Московская)

    case provider.name
    when 'Boxberry'
      courier? || I18n.t(:hack, scope: %i[custom_date_intervals boxberry]).include?(deliverable_name)
    end
  end

  def time_after_delivery_date_will_change
    Time.current.middle_of_day + 2.hours # 14:00
  end
end
