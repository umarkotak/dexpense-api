class CategoriesController < ApiController
  def index_static
    render_response(
      data: Const::TRANSACTION_CATEGORIES_MAP.map do |k, v|
        { name: "category", value: k, label: v[params[:locale]] }
      end
    )
  end
end
