class PagesController < ApplicationController

  layout :layout_switch

  def base
    @layout = 'base'
  end

  def mixed
    @layout = 'mixed'
  end

  def plain
    @layout = 'plain'
  end


  private

  def layout_switch
    @layout
  end

end