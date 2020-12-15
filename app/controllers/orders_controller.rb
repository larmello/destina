class OrdersController < ApplicationController
  before_action :set_request_product, except: %i[index edit destroy]
  before_action :set_order, only: %i[show edit update destroy]

  def index
    @orders = Order.all.includes(:request, :user, request: :user)
  end

  def show
  end

  def create
    @order = Order.new(order_params)
    @order.request = @request
    @order.product = @product
    @order.user_id = current_user.id
    if @order.save
      redirect_to orders_path, notice: 'Ordem criada com sucesso.'
    else
      render :new
    end
    @request.update_attributes(status: (@request.status = "Aprovado"))
    @product.update_attributes(quantity: (@product.quantity - @request.quantity))
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Ordem atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url
    @order.request.update_attributes(status: (@order.request.status = "Em analise"))
    @order.product.update_attributes(quantity: (@order.product.quantity + @order.request.quantity))
  end

  private

  def order_params
    params.require(:order).permit(:request_id, :product_id, :status, :user_id)
  end

  def set_request_product
    @request = Request.find(params[:request_id])
    @product = Product.find(params[:product_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
