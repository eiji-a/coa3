
class Coa3Application
  
  # CONSTANTS
  MIMETYPE_BASE = 'application/x-coa3-'
  STORAGETYPE = Content::FILE

  # INSTANCE VARIABLES

  # CLASS METHODS
  def self.mimetype
    raise StandardError, 'please inherit Coa3Application'
  end

  # INSTANCE METHODS
  def initialize(content = nil)
    if content == nil
      @content = Content.new
      @content.mimetype = self.class.mimetype
      @content.storagetype = STORAGETYPE
      @body = nil
    else
      @content = content
      @body = YAML.load(@content.body)
    end
  end

  def id
    @content.id
  end

  def content
    @content
  end

  def title=(title)
    @content.title = title
  end

  def title
    @content.title
  end

  def set(key, value)
    @body[key] = value
  end

  def get(key)
    @body[key]
  end

  def save
    @content.body = YAML.dump(@body)
    super
  end

  def save!
    @content.body = YAML.dump(@body)
    super
  end

  def destroy
    @content.destroy
  end

end
