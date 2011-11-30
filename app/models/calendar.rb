# -*- coding: utf-8 -*-

class Calendar

  # CONSTANTS
  WDAY = ['日', '月', '火', '水', '木', '金', '土']
  WDAY_E = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday',
            'Friday', 'Saturday']
  MONTHDAY = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

  MONTH_NAME_E = ['January', 'February', 'March', 'April',
                  'May', 'June', 'July', 'August',
                  'September', 'October', 'November', 'December']
  MONTH_NAME_J = ['睦月', '如月', '弥生', '卯月', '皐月', '水無月',
                  '文月', '葉月', '長月', '神無月', '霜月', '師走']

  def valid_day?(year, month, day)
    date = Time.local(year, month, day)
  end

  def leap?(year)
    return true if year % 4 == 0 && year % 100 != 0
    false
  end

end
