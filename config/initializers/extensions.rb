class ActiveRecord::Base
  include SharedMethods
end

Time::DATE_FORMATS[:date_format] = '%d/%m/%Y %l:%M %p'
Date::DATE_FORMATS[:date_format] = '%d/%m/%Y'
Date::DATE_FORMATS[:date_month] = '%d-%B'
Time::DATE_FORMATS[:display_format] = '%d/%m/%y %H:%M'
Date::DATE_FORMATS[:month_year] = '%b %Y'
Time::DATE_FORMATS[:month_year] = '%b %Y'
Date::DATE_FORMATS[:full_month_year] = '%B %Y'
Time::DATE_FORMATS[:full_month_year] = '%B %Y'