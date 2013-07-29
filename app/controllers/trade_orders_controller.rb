class TradeOrdersController < ApplicationController

  CURRENCY = 'USD'

  skip_before_filter :authenticate_user!,
    :only => :book

  def new
    @trade_order = TradeOrder.new
  end

  def create
    @trade_order = TradeOrder.build_with_params(params[:trade_order])
    @trade_order.user = current_user

    if @trade_order.save
      result = @trade_order.execute!

      if result[:trades].zero?
        notice = t(:order_saved)
      else
        notice = t(:order_filled,
          :how => (t(@trade_order.destroyed?) ? t(:completely) : t(:partially)),
          :action => (t(@trade_order.buying?) ? t(:bought) : t(:sold)),
          :traded_btc => ("%.4f" % result[:total_traded_btc]),
          :amount => ("%.4f" % result[:total_traded_currency]),
          :currency => result[:currency],
          :ppc => ("%.5f" % result[:ppc]))
      end

      redirect_to account_trade_orders_path,
        :notice => notice
    else
      @trade_orders = current_user.trade_orders.paginate(:page => params[:page], :per_page => 16)
      @sales = _get_orders(CURRENCY, :sell)
      @purchases = _get_orders(CURRENCY, :buy)
      render :action => :index
    end
  end

  def activate
    trade_order = current_user.trade_orders.find(params[:trade_order_id])
    result = trade_order.activate!
    if result[:trades].zero?
      notice = t(:order_saved)
    else
      notice = t(:order_filled,
        :how => (t(trade_order.destroyed?) ? t(:completely) : t(:partially)),
        :action => (t(trade_order.buying?) ? t(:bought) : t(:sold)),
        :traded_btc => ("%.4f" % result[:total_traded_btc]),
        :amount => ("%.4f" % result[:total_traded_currency]),
        :currency => result[:currency],
        :ppc => ("%.5f" % result[:ppc]))
    end

    redirect_to account_trade_orders_path,
      :notice => notice
  end

  def index
    @trade_orders = current_user.trade_orders.paginate(:page => params[:page], :per_page => 16)
    @sales = _get_orders(CURRENCY, :sell)
    @purchases = _get_orders(CURRENCY, :buy)
    @trade_order = TradeOrder.new
  end

  def my_orders
    @trade_orders = current_user.trade_orders.paginate(:page => params[:page], :per_page => 16)
    render layout: 'account'
  end

  def destroy
    current_user.trade_orders.find(params[:id]).destroy

    redirect_to account_trade_orders_path,
      :notice => (t :order_deleted)
  end

  def book
    @sales = _get_orders(CURRENCY, :sell)
    @purchases = _get_orders(CURRENCY, :buy)

    respond_to do |format|
      format.html
      format.xml
      format.json do
        json = {
          :bids => [],
          :asks => []
        }

        { :asks => @sales, :bids => @purchases }.each do |k,v|
          v.each do |to|
            json[k] << {
              :timestamp => to[:created_at].to_i,
              :price => to[:price].to_d,
              :amount => to[:amount],
              :currency => to[:currency]
            }
          end
        end

        render :json => json
      end
    end
  end

  private

  def _get_orders(currency, type)
    TradeOrder.get_orders type, :user => current_user, :currency => currency, :separated => params[:separated]
  end
end
