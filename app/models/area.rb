class Area < ActiveRecord::Base

  has_and_belongs_to_many :users
  belongs_to :team
  markdownize! :description

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, :id],
    ]
  end


  scope :priority, ->(priority) { where("priority = ?", priority) }
  scope :writer_coverage, ->(coverage) { where("writer_coverage = ?", coverage) }
  scope :low_risk, Proc.new { |area| area.support_status == 1 }
  scope :medium_risk, Proc.new { |area| area.support_status == 2 }
  scope :high_risk, Proc.new { |area| area.support_status == 3 }
  scope :unknown_risk, Proc.new { |area| area.support_status == 0 }

  
  def self.status(status)
    areas = Area.select { |a| a.support_status == status}
    return areas
  end
    
  def self.cost(cost)
    areas = Area.select { |a| a.burden == cost }
    return areas
  end
  
  def support_status

    if self.priority == nil || self.writer_coverage == nil || self.priority == 0 
      0
    elsif self.priority > self.writer_coverage + 1
      3
    elsif self.priority > self.writer_coverage
      2
    else
      1
    end
   
  end

  def burden
    if self.writer_coverage == nil || self.support == nil 
      0
    elsif self.writer_coverage == 0 || self.support == 0
      0
    else
      self.writer_coverage + self.support
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

  def coverage_narrative
    case self.writer_coverage
    when 0
      "no"
    when 1
      "a little"
    when 2
      "some"
    when 3
      "substantial"
    end
  end
  
  def burden_narrative
    case self.burden
    when 0
      "Unknown"
    when 1..4
      "Low"
    when 5..6
      "High"
    end
  end

  def support_narrative
    case self.support_status
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
