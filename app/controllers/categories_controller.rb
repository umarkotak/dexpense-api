class CategoriesController < ApiController
  def index_static
    render_response(
      data: Const::TRANSACTION_CATEGORIES_MAP.map do |k, v|
        {
          name: "category",
          value: k,
          label: v[params[:locale]],
          icon_url: v[:icon_url] != "" ? v[:icon_url] : Const::DEFAULT_ICON_URL
        }
      end
    )
  end
end
