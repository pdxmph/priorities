module ListsHelper

  def priority_select_options
    [
      ['P1 (High Priority)', 3],
      ['P2 (Medium Priority)', 2], 
      ['P3 (Low Priority)', 1],
      ['Unset', 0]
    ]
  end

  def effort_select_options
    [
      ['High Effort', 3],
      ['Medium Effort', 2],
      ['Low Effort', 1], 
      ['No Effort', 0]
    ]
  end

  def priority_badge(goal)
    case goal.priority
    when 3
      content_tag(:span, "P1", class: "label label-danger", title: "High Priority")
    when 2
      content_tag(:span, "P2", class: "label label-warning", title: "Medium Priority")
    when 1
      content_tag(:span, "P3", class: "label label-info", title: "Low Priority")
    else
      content_tag(:span, "?", class: "label label-default", title: "Unset Priority")
    end
  end

  def status_board(list)
    well_aligned = Goal.health(1, list)
    needs_attention = Goal.health(2, list)
    under_resourced = Goal.health(3, list)
    unknown = Goal.health(0, list)
    
    capture_haml do
      if under_resourced.count > 0
        haml_tag :span, class: "glyphicon glyphicon-fire text-danger"
        haml_concat " #{under_resourced.count} under-resourced"
        haml_tag :span, style: "padding-right:1.5em;"
      end

      if needs_attention.count > 0
        haml_tag :span, class: "glyphicon glyphicon-warning-sign text-warning"
        haml_concat " #{needs_attention.count} need attention"
        haml_tag :span, style: "padding-right:1.5em;"
      end

      if well_aligned.count > 0
        haml_tag :span, class: "glyphicon glyphicon-ok text-success"
        haml_concat " #{well_aligned.count} well-aligned"
        haml_tag :span, style: "padding-right:1.5em;"
      end

      if unknown.count > 0
        haml_tag :span, class: "glyphicon glyphicon-question-sign text-muted"
        haml_concat " #{unknown.count} unknown"
      end
    end
  end

  def alignment_status_badge(goal)
    gap = goal.priority_effort_gap
    return content_tag(:span, "Unknown", class: "label label-default") if gap.nil?
    
    case gap
    when 2..3
      content_tag(:span, "Under-resourced", class: "label label-danger")
    when 1
      content_tag(:span, "Needs attention", class: "label label-warning")
    when 0
      content_tag(:span, "Well-aligned", class: "label label-success")
    when -3..-1
      content_tag(:span, "Over-invested", class: "label label-info")
    end
  end

end
