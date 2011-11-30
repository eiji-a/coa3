require 'estraier'
include Estraier

class Searcher
  # CONSTANTS
  #DBFILE = '/Users/eiji/work/coa3_storage/estdb'
  URI = 'contents/'

  # CLASS METHODS
  def Searcher.open(dbfile)
    @searcher = Searcher.new(dbfile)
    begin
      yield(@searcher)
    ensure
      @searcher.close
    end
  end

  # CONSTRUCTORS
  def initialize(dbfile)
    @db = Database.new
    unless @db.open(dbfile,
                    Database::DBCREAT |
                    Database::DBREADER |
                    Database::DBWRITER)
      raise ArgumentError, @db.err_msg(@db.error)
    end
  end

  # PUBLIC METHODS
  def close
    unless @db.close
      raise RuntimeError, "can't close DB: #{@db.err_msg(@db.error)}"
    end
  end

  def search(condition)
    list = {}
    cond = Condition.new
    cond.set_phrase(condition)
    result = @db.search(cond)
    result.doc_num.times do |i|
      doc = @db.get_doc(result.get_doc_id(i), 0)
      cid = doc.attr("cid")
      title = doc.attr("@title")
      if cid && title
        list[cid.to_i] = title
      end
    end
    list
  end

  def regist(content)
    erase(content)

    doc = Document.new
    cid = content.id
    doc.add_attr('@uri', URI + cid.to_s)
    doc.add_attr('@title', content.title)
    doc.add_attr('cid', cid.to_s)
    doc.add_text(content.title)
    doc.add_text(content.bodytext)
    doc.add_text(content.path)

    unless @db.put_doc(doc, Database::PDCLEAN)
      raise RuntimeError, "can't put document: #{cid}: #{@db.err_msg(@db.error)}"
    end
    true
  end

  def erase(content)
    cid = content.id
    did = @db.uri_to_id(URI + cid.to_s)
    if did != -1
      unless @db.out_doc(did, Database::ODCLEAN)
        raise RuntimeError, "can't remove document: #{cid}"
      end
      true
    else
      false
    end
  end
end
