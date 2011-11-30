# -*- coding: utf-8 -*-

# GTDアクション

class GtdAction < Coa3Application

  # CONSTANTS
  STATUS = 'status'
  NEXT = 'next'

  # -- STATUS
  ACTIVE = 'active'
  FINISHED = 'finished'
  # -- NEXT
  YES = 'yes'
  NO  = 'no'

  # CLASS METHODS

  def GtdAction.mimetype
    MIMETYPE_BASE + 'gtd-action'
  end

  # INSTANCE METHODS

  def status
    get(STATUS)
  end

  def status=(status)
    set(STATUS, status)
  end

  def next
    get(NEXT)
  end

  def next=(nx)
    set(NEXT, nx)
  end
end
