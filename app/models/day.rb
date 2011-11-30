class Day
  WEEKDAY  = ''
  SATURDAY = '_sat'
  HOLIDAY  = '_holi'

  def initialize(date)
    @date = date
    @holiday = []
    @schedule = []
  end

  def add_schedule(sche)
    if sche.content.user.userid == Const.get('calendar_manager')
      @holiday << sche
    else
      @schedule << sche
    end
  end

  def schedule
    @schedule
  end

  def holiday
    @holiday
  end

  def strftime(pat)
    @date.strftime(pat)
  end

  def year
    @date.year
  end

  def month
    @date.month
  end

  def day
    @date.day
  end

  def wday
    @date.wday
  end

  def to_s
    @date.strftime("%Y%m%d")
  end

  def wday_color
    if @holiday.size > 0
      WDAY_COLOR[0]
    else
      WDAY_COLOR[@date.wday]
    end
  end

  def type
    @ext = if @holiday.size > 0 || @date.wday == 0 then
             HOLIDAY
           elsif @date.wday == 6 then
             SATURDAY
           else
             WEEKDAY
           end
  end

end
