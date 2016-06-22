class ColorsController < ApplicationController

  before_action :authenticate_user!

  def index

    @colors = current_user.colors.all

  end

end
