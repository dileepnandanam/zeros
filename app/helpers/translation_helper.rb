module TranslationHelper
  def t(key)
    Malayalam[key] && false || (key.gsub "_", " ").camelize
  end
end