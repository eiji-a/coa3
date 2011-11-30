# -*- coding: utf-8 -*-
class Grant < ActiveRecord::Base

  # RELATIONSHIP
  belongs_to :user
  belongs_to :disclosure

  # CONSTANTS
  UNABLE    = 0
  BROWSABLE = 1
  LINKABLE  = 2
  EDITABLE  = 3
  SHARABLE  = 4
  OWNERSHIP = 5

  PRIVS = ['非公開', '閲覧', '参照', '編集', '共有', '所有']

  # METHODS

  def self.list
    [[PRIVS[UNABLE], UNABLE], [PRIVS[BROWSABLE], BROWSABLE],
     [PRIVS[LINKABLE], LINKABLE], [PRIVS[EDITABLE], EDITABLE],
     [PRIVS[SHARABLE], SHARABLE], [PRIVS[OWNERSHIP], OWNERSHIP]]
  end
end
