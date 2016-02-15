module ApplicationHelper

  def rank_label(level)

    case level
    when 1
      return "Low"
    when 2
      return "Medium"
    when 3
      return "High"
    end
  end

  def rank_class(level)
    case level
    when 1
      return "info"
    when 2
      return "warning"
    when 3
      return "danger"
    end
  end
  
  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end
 
  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:span, message, class: "alert alert-dismissable #{bootstrap_class_for(msg_type)} fade in") do 
                            concat message 
            end)
    end
    nil
  end

  
end
