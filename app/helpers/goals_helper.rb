module GoalsHelper
  
  def display_label(level, property)
    case level
    when 0
      label_class = "default"
      label = "No"
    when 1
      if property == "Coverage"
        label_class = "danger"
      else
        label_class = "success"
      end
      label = "Low"
    when 2
      label_class = "warning"
      label = "Medium"
    when 3
      if property == "Coverage"
        label_class = "success"
      else
        label_class = "danger"
      end
      label = "High"
    end

    capture_haml do
      haml_tag :span, class: "label-#{label_class} label" do
        haml_concat "#{label} #{property}"
      end
    end
  end

  def health_indicator(goal)
    case goal.health
    when 0
      glyph = "glyphicon-question-sign"
      indicator_class = "muted"
    when 1
      glyph = "glyphicon-ok"
      indicator_class = "success"
    when 2
      glyph = "glyphicon-warning-sign"
      indicator_class = "warning"
    when 3
      glyph = "glyphicon-fire"
      indicator_class = "danger"
    end
     capture_haml do
       haml_tag :span, class: "glyphicon #{glyph} text-#{indicator_class}"
     end    
  end




  def goal_button_properties(goal,prop,list)
    case prop
    when "Support"
      goal_prop = goal.support
    when "Priority"
      goal_prop = goal.priority
    end
    
    case goal_prop
    when 0
      word = "No"
      btn_class = "danger"
    when 1
      word = "Low"
      if prop == "Support"
        btn_class = "danger"
      else
        btn_class ="primary"
      end
    when 2
      word = "Medium"
      btn_class = "warning"
    when 3
      word = "High"
      if prop == "Support"
        btn_class = "success"
      else
        btn_class = "danger"
      end
    when nil
      btn_class = "default"
      if can? :manage, list
        word = "Set"
      else
        word = "Unset"
      end
    end
    return [btn_class, word]
  end
end

