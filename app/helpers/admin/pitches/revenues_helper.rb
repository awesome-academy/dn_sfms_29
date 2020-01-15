module Admin::Pitches::RevenuesHelper
  def order
    [{id: t("generate.asc"), name: t("generate.asc_total")},
     {id: t("generate.desc"), name: t("generate.desc_total")}]
  end
end
