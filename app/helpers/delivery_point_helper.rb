module DeliveryPointHelper
  def format_working_hours(delivery_point)
    working_hours = delivery_point.working_hours
    working_hours_to_json = JSON.parse(working_hours.tr('\\', '').gsub('=>', ':'))

    result = ''
    working_hours_to_json.each do |hours|
      case hours['weekday-id']
      when 1
        result += 'Пн'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 2
        result += 'Вт'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 3
        result += 'Ср'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 4
        result += 'Чт'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 5
        result += 'Пт'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 6
        result += 'Сб'
        if hours['begin-worktime'].nil?
          result += ' — выходной; '
        else
          result += ": c #{Time.zone.parse(hours['begin-worktime']).strftime('%H:%M')} до #{Time.zone.parse(hours['end-worktime']).strftime('%H:%M')}; "
        end
      when 7
        result += 'Вс'
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
