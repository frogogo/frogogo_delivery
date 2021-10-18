json.links do
  json.self url_for(page: relation.current_page, per_page: relation.limit_value, only_path: false)
  json.first url_for(page: 1, per_page: relation.limit_value, only_path: false)

  if relation.prev_page.present?
    json.prev url_for(page: relation.prev_page, per_page: relation.limit_value, only_path: false)
  else
    json.prev nil
  end

  if relation.next_page.present?
    json.next url_for(page: relation.next_page, per_page: relation.limit_value, only_path: false)
  else
    json.next nil
  end

  json.last url_for(page: relation.total_pages, per_page: relation.limit_value, only_path: false)
end
