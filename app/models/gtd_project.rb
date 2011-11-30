# -*- coding: utf-8 -*-

# GTDプロジェクト

class GtdProject < Coa3Application

  # CONSTANTS
  STATUS = 'status'
  DESCRIPTION = 'description'

  # -- STATUS
  ACTIVE = 'active'
  FINISHED = 'finished'

  # CLASS METHODS

  def GtdProject.mimetype
    MIMETYPE_BASE + 'gtd-project'
  end

  def GtdProject.list(user_id)
    tmpl = Content.find(:all,
                        :conditions => ['mimetype = ?', GtdProject.mimetype],
                        :order => 'title')
    list = []
    tmpl.each do |l|
      list << GtdProject.new(l) if l.browsable?(user_id)
    end
    list
  end

  # INSTANCE METHODS

  def activate
    set(STATUS, ACTIVE)
  end

  def finish
    set(STATUS, FINISH)
  end

  def active?
    return get(STATUS) == ACTIVE
  end

  def description
    get(DESCRIPTION)
  end

  def description=(desc)
    set(DESCRIPTION, desc)
  end

  def actions(status = GtdAction::ACTIVE)
    actions = []
    @content.children.each do |c|
      next if c.mimetype != GtdAction.mimetype
      ac = GtdAction.new(c)
      next if status != nil && ac.status != status
      actions << ac
    end
    actions
  end

end
