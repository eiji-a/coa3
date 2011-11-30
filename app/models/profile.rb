
class Profile < Coa3Application

  # CONSTANTS
  MAIL_ADDRESS = 'mail_address'
  GTD_PROJECT_FOLDER = 'gtd_project_folder'
  GTD_INBOX = 'gtd_inbox'

  def Profile.mimetype
    MIMETYPE_BASE + 'profile'
  end

  #def mimetype
  #  MIMETYPE_BASE + 'profile'
  #end

  def mail_address
    get(MAIL_ADDRESS)
  end

  def mail_address=(addr)
    set(MAIL_ADDRESS, addr)
  end

  def gtd_project_folder
    get(GTD_PROJECT_FOLDER)
  end

  def gtd_project_folder=(folderid)
    set(GTD_PROJECT_FOLDER, folderid)
  end

  def gtd_inbox
    get(GTD_INBOX)
  end

  def gtd_inbox=(contentid)
    set(GTD_INBOX, contentid)
  end

end
