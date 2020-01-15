module ApplicationHelper
  def full_title page_title
    base_title = I18n.t "generate.page_title"
    page_title.blank? ? base_title : (page_title << "|" << base_title)
  end

  def gender param
    param ? I18n.t("generate.male") : I18n.t("generate.female")
  end
end
