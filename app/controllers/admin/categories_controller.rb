class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :toggle_status]

  def index
    @categories = Category.order(:name)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "Category created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def show
    redirect_to edit_admin_category_path(@category)
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "Category updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy!
    redirect_to admin_categories_path, notice: "Category deleted successfully."
  end

  def toggle_status
    @category.update!(active: !@category.active?)
    redirect_to admin_categories_path, notice: "Category status updated."
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :active)
  end
end
