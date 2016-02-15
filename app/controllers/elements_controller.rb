class ElementsController < ApplicationController

  def store_element

    @element = Element.new
    @element.content = params[:html]
    @element.page_id = params[:page_id]
    @element.checksum = Digest::MD5.hexdigest(h)
    @element.save

  end
  

end
