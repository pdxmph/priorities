class Goal < ActiveRecord::Base

  belongs_to :team
  belongs_to :list

  scope :priority, ->(priority,list) { where("priority = ? AND list_id = ?", priority, list.id) }
  scope :effort, ->(effort,list) { where("effort = ? AND list_id != ?", effort, list.id) }
  scope :low_risk, Proc.new { |area| area.support_status == 1 }
  scope :medium_risk, Proc.new { |area| area.support_status == 2 }
  scope :high_risk, Proc.new { |area| area.support_status == 3 }
  scope :unknown_risk, Proc.new { |area| area.support_status == 0 }
  scope :all_except, ->(goal) { where.not(id: goal) }

  markdownize! :description
  
  def self.health(health, list)
    goals = list.goals.select { |g| g.health == health}
    return goals
  end
    
  def self.cost(cost, list)
    goals = list.goals.select { |g| g.burden == cost}
    return goals
  end


  def burden
    if self.support == nil or self.effort == nil or  self.support == 0 or self.effort == 0 
      0
    else
      self.support + self.effort
    end
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
