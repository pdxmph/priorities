class Goal < ActiveRecord::Base

  belongs_to :team
  belongs_to :list

  scope :priority, ->(priority) { where("priority = ?", priority) }
  scope :writer_coverage, ->(coverage) { where("writer_coverage = ?", coverage) }
  scope :low_risk, Proc.new { |area| area.support_status == 1 }
  scope :medium_risk, Proc.new { |area| area.support_status == 2 }
  scope :high_risk, Proc.new { |area| area.support_status == 3 }
  scope :unknown_risk, Proc.new { |area| area.support_status == 0 }
  markdownize! :description
  
  def self.health(health, list)
    goals = list.goals.select { |g| g.health == health}
    return goals
  end
    
  def self.cost(cost)
    areas = Area.select { |a| a.burden == cost }
    return areas
  end
  
  def health

    if self.priority == nil || self.support == nil || self.priority == 0 
      0
    elsif self.priority > self.support + 1
      3
    elsif self.priority > self.support
      2
    else
      1
    end
   
  end

  def priority_narrative
    case self.priority
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

  def support_narrative
    case self.health
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
