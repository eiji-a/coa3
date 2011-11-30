

require 'yaml'

class Const
  CONFIG = 'config/coa3.yml'

  @@conf = nil

  def Const.init
    @@conf = YAML.load_file(Rails.root + CONFIG)
  end

  def Const.get(name)
    Const.init if @@conf == nil
    @@conf[name]
  end
end

