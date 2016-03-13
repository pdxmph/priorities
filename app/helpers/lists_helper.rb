module ListsHelper

  def status_board(list)

    good = Goal.health(1,list)
    medium = Goal.health(2,list)
    poor = Goal.health(3,list)
    unknown = Goal.health(0,list)
    
    capture_haml do
      if poor.count > 0
        haml_tag :span, class: "glyphicon glyphicon-fire text-danger" 
        haml_concat poor.count
        haml_tag :span, style: "padding-right:1.5em;"
      end

      if medium.count > 0
      haml_tag :span, class: "glyphicon glyphicon-warning-sign text-warning" 
      haml_concat medium.count
      haml_tag :span, style: "padding-right:1.5em;"
      end

      if good.count > 0
      haml_tag :span, class: "glyphicon glyphicon-ok text-success" 
      haml_concat good.count
      haml_tag :span, style: "padding-right:1.5em;"

      end

      if unknown.count > 0
      haml_tag :span, class: "glyphicon glyphicon-question-sign text-muted" 
      haml_concat unknown.count
      end

    end

  
      
  end

end
