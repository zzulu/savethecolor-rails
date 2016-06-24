class Api::ColorsController < ApplicationController
  # protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  # http_basic_authenticate_with :name => "myfinance", :password => "credit123"

  skip_before_filter :authenticate_user! # we do not need devise authentication here
  before_filter :fetch_user, :except => [:index, :destroy]

  def fetch_user
    @user = User.where(authentication_token: params[:auth_token]).first
  end

  def index
    @colors = Color.all

    respond_to do |format|
      format.json { render json: @colors }
    end
  end

  def create

    unless @user
      respond_to do |format|
        format.json { render json: { success: false, info: "Expired Session. Please sign in again." }}
      end
    else

      @color = Color.new
      @color.user_id = @user.id
      @color.origin = params[:color][:origin]
      @color.hex = params[:color][:hex]

      respond_to do |format|
        if @color.save

          Pusher.trigger( @user.email.to_s , 'add_color_event', {
            id: @color.id,
            color: @color.hex
          })

          format.json { render json: { success: true, info: "Saved", data: @color }, status: :created }
        else
          format.json { render json: @color.errors, status: :unprocessable_entity }
        end
      end

    end
  end

  def destroy

    @color = Color.find(params[:color][:id])

    Pusher.trigger( @color.user.email.to_s , 'delete_color_event', {
      id: @color.id
    })

    respond_to do |format|
      if @color.destroy
        format.json { render json: { success: true, info: "Deleted" } }
      else
        format.json { render json: @color.errors, status: :unprocessable_entity }
      end
    end
  end
end
