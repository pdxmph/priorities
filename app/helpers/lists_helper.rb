module ListsHelper

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
