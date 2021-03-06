class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :index]
  before_action :admin_required
  layout 'admin'
  def index
        if params[:category].blank?
       @products = Product.all
     else
       @category_id = Category.find_by(name: params[:category]).id
       @products = Product.where(category_id: @category_id)
     end
  end

  def show
   @product = Product.find(params[:id])
 end

  def new
    @product = Product.new
    @categories = Category.all.map{ |c| [c.name, c.id]}
    @photos = @product.photos.build
  end

  def create
    @product = Product.new(product_params)
    @product.category_id = params[:category_id]
    if @product.save
      if params[:photos] != nil
       params[:photos]['avatar'].each do |a|
         @photo = @product.photos.create(:avatar => a)
       end
     end
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all.map{ |c| [c.name, c.id]}
  end

  def update
    @product = Product.find(params[:id])
    @product.category_id = params[:category_id]
    if params[:photos] != nil
     @product.photos.destroy_all            # 如果有新参数传过来，就删掉原来的图，以新的为准
     params[:photos]['avatar'].each do |a|
       @picture = @product.photos.create(:avatar => a)
     end

     @product.update(product_params)
     redirect_to admin_products_path

     elsif @product.update(product_params)
       redirect_to admin_products_path

   else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
      redirect_to admin_products_path
  end


  private

  def product_params
    params.require(:product).permit(:title, :description, :quantity, :price, :image, :category_id, :particulars)
  end
end
