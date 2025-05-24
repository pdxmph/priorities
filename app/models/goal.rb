class Goal < ActiveRecord::Base

  belongs_to :team, optional: true
  belongs_to :list

  validates :name, presence: true
  validates :priority, :support, :effort, inclusion: { in: 0..3 }, allow_nil: true

  scope :priority, ->(priority,list) { where("priority = ? AND list_id = ?", priority, list.id) }
  scope :effort, ->(effort,list) { where("effort = ? AND list_id != ?", effort, list.id) }
  scope :by_alignment, ->(level) { select { |g| g.alignment_risk == level } }
  scope :all_except, ->(goal) { where.not(id: goal) }

  markdownize! :description
  
  # Core alignment logic - compares stated priority vs actual effort
  def priority_effort_gap
    return nil if priority.blank? || effort.blank? || priority == 0
    priority - effort  # Positive = under-resourced, Negative = over-invested
  end

  def alignment_risk
    gap = priority_effort_gap
    return 0 if gap.nil?  # Unknown/unset
    
    case gap
    when 2..3 then 3     # Critical: High priority, very low effort
    when 1 then 2        # Warning: Some misalignment  
    when 0 then 1        # Good: Effort matches priority
    when -1..-3 then 1   # Good: Over-investing (not necessarily bad)
    end
  end

  # Legacy method for backward compatibility
  def health
    alignment_risk
  end

  def self.health(health_level, list)
    list.goals.select { |g| g.alignment_risk == health_level }
  end
    
  def self.cost(cost, list)
    goals = list.goals.select { |g| g.burden == cost}
    return goals
  end

  def burden
    return 0 if support.blank? || effort.blank? || support == 0 || effort == 0 
    support + effort
  end

  def priority_narrative
    case priority
    when 0
      "Undetermined"
    when 1
      "Low"
    when 2
      "Medium"
    when 3
      "High"
    end
  end

  def effort_narrative
    case effort
    when 0
      "None"
    when 1
      "Low"
    when 2
      "Medium"
    when 3
      "High"
    end
  end

  def alignment_narrative
    gap = priority_effort_gap
    return "Unknown" if gap.nil?
    
    case gap
    when 2..3
      "⚠️ Under-resourced (Priority: #{priority_narrative}, Effort: #{effort_narrative})"
    when 1
      "⚡ Needs attention (Priority: #{priority_narrative}, Effort: #{effort_narrative})"
    when 0
      "✅ Well-aligned (Priority: #{priority_narrative}, Effort: #{effort_narrative})"
    when -1..-3
      "📈 Over-invested (Priority: #{priority_narrative}, Effort: #{effort_narrative})"
    end
  end

  # Legacy method for backward compatibility
  def support_narrative
    case alignment_risk
    when 0
      "at Unknown Risk"
    when 1
      "at Very Little Risk"
    when 2
      "at Some Risk"
    when 3
      "at High Risk"
    end
  end
  
end
