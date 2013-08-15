module TranslationHelper
  def t(key)
    Malayalam[key] || (key.sub "_", " ").camelize
  end
end