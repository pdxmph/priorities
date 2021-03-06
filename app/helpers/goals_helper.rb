module GoalsHelper
  
  def display_label(level, property)
    case level
    when 0
      label_class = "default"
      label = "No"
    when 1
      if property == "Health"
        label_class = "success"
        label = "Good"
      else
        label_class = "success"
        label = "Low"
      end
    when 2
      label_class = "warning"
      label = "Medium"
    when 3
      if property == "Effort" or property == "Priority"
        label_class = "danger"
        label = "High"
      elsif property == "Health"
        label_class = "danger"
        label = "Poor"
      end
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


  def burden_label(goal)
    case goal.burden
    when 0
      label_class = "default"
      label = "No"
      glyph = "question-sign"
    when 1..2
      label_class = "success"
      label = "Low"
      glyph = "ok-sign"
    when 3..4
      label_class = "warning"
      label = "Medium"
      glyph = "warning-sign"
    when 5..6
      label_class = "danger"
      label = "High"
      glyph = "exclamation-sign"
    end
    capture_haml do
      haml_tag :span, class: "label-#{label_class} label" do
        haml_tag :span, class: "glyphicon glyphicon-#{glyph}"
        haml_concat "#{label} Cost"
      end
    end



  end

  def burden_indicator(goal)
    case goal.burden
    when 0
      indicator_class = "muted"
    when 1..2
      indicator_class = "success"
    when 3..4
      indicator_class = "warning"
    when 5..6
      indicator_class = "danger"
    end
    
    capture_haml do
      haml_tag :span, class: "label label-#{indicator_class}"
    end    
    
  end
  

  def goal_button_properties(goal,prop,list)
    case prop
    when "Support"
      goal_prop = goal.support
    when "Priority"
      goal_prop = goal.priority
    when "Effort"
      goal_prop = goal.effort
    end
    
    case goal_prop
    when 0
      if prop == "Effort"
        word = "No"
        btn_class = "default"
      else
        word = "No"
        btn_class = "danger"
      end
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

