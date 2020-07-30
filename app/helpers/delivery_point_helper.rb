module DeliveryPointHelper
  def format_working_hours(delivery_point)
    working_hours = delivery_point.working_hours
    working_hours_to_json = JSON.parse(working_hours.tr('\\', '').gsub('=>', ':'))

    result = ''
    working_hours_to_json.each do |hours|
      case hours['weekday-id']
      when 1
        result += 'пн'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 2
        result += 'вт'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 3
        result += 'ср'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 4
        result += 'чт'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 5
        result += 'пт'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 6
        result += 'сб'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 7
        result += 'вс'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')};"
        end
      end
    end

    result
  end
end
