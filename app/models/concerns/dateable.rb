module Dateable
  extend ActiveSupport::Concern

  DIGIT_REGEXP = /\d+/
  # Date => days count
  HOLIDAYS = {
    Date.parse('20211104') => 0,
    Date.parse('20211105') => 1,
    Date.parse('20211106') => 0,
    Date.parse('20211107') => 0
  }

  def date_interval
    self[:date_interval].scan(DIGIT_REGEXP).max
  end

  def estimate_delivery_date
    estimated_delivery_date
  end

  def estimated_delivery_date
    calculate_estimated_delivery_date(Date.current)
  end

  def expires_in
    time_after_delivery_date_will_change - Time.current
  end

  private

  def calculate_estimated_delivery_date(date)
    delivery_date = date
    delivery_date += 1.day if Time.current > time_after_delivery_date_will_change

    delivery_date -= 1.day if courier?

    days_count = date_interval.to_i

    # HACK: add +1 day to delivery interval
    days_count += 1 if override_days_count?

    days_count.times do
      if delivery_date.friday?
        if [6, 7].include?(I18n.t(:avaliable_days_for_delivery)[subdivision_name])
          delivery_date += 1.day
        else
          delivery_date = delivery_date.next_weekday
        end
      elsif delivery_date.saturday?
        if I18n.t(:avaliable_days_for_delivery)[subdivision_name] == 7
          delivery_date += 1.day
        else
          delivery_date = delivery_date.next_weekday
        end
      else
        delivery_date += 1.day
      end
    end

    delivery_date += HOLIDAYS.fetch(delivery_date, 0).days

    delivery_date
  end

  def subdivision_name
    deliverable.is_a?(Locality) ? deliverable.subdivision.name.to_sym : deliverable.name.to_sym
  end

  def default_time_intervals(date)
    if I18n.t(:avaliable_days_for_delivery).keys.include?(subdivision_name)
      if date.in?(HOLIDAYS.keys)
        return I18n.t("#{subdivision_name}.sunday", scope: %i[time_intervals])
      end

      I18n.t(
        "#{subdivision_name}.#{Date::DAYS_INTO_WEEK.invert[date.wday]}",
        scope: %i[time_intervals]
      )
    else
      I18n.t(:default, scope: %i[time_intervals])
    end
  end

  def override_days_count?
    return if subdivision_name == (:Москва || :Московская)

    courier? || I18n.t(:hack, scope: %i[custom_date_intervals boxberry]).include?(subdivision_name)
  end

  def time_after_delivery_date_will_change
    Time.current.middle_of_day + 2.hours # 14:00
  end

  def excluded_on_holidays?
    return unless courier? && deliverable.is_a?(Locality)

    I18n.t('excluded_deliverables.boxberry.courier.subdivisions')
      .include?(deliverable.subdivision.name)
  end
end
