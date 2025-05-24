# Service object to analyze priority alignment across a list
class PriorityAnalysisService
  def initialize(list)
    @list = list
    @goals = list.goals.includes(:team)
  end

  def alignment_report
    {
      critical_gaps: goals_by_risk(3),
      needs_attention: goals_by_risk(2), 
      well_aligned: goals_by_risk(1),
      unknown: goals_by_risk(0),
      metrics: calculate_metrics,
      recommendations: generate_recommendations
    }
  end

  private

  attr_reader :list, :goals

  def goals_by_risk(level)
    goals.select { |g| g.alignment_risk == level }
  end

  def calculate_metrics
    total_goals = goals.count
    return empty_metrics if total_goals.zero?

    {
      total_goals: total_goals,
      alignment_percentage: (goals_by_risk(1).count.to_f / total_goals * 100).round(1),
      critical_percentage: (goals_by_risk(3).count.to_f / total_goals * 100).round(1),
      total_effort_points: goals.sum(&:effort),
      total_priority_points: goals.sum(&:priority),
      average_gap: average_priority_effort_gap
    }
  end

  def average_priority_effort_gap
    gaps = goals.map(&:priority_effort_gap).compact
    return 0 if gaps.empty?
    (gaps.sum.to_f / gaps.size).round(2)
  end

  def generate_recommendations
    recs = []
    
    if goals_by_risk(3).any?
      recs << "🚨 #{goals_by_risk(3).count} high-priority items are under-resourced"
    end
    
    if goals_by_risk(2).any?
      recs << "⚠️ #{goals_by_risk(2).count} items need attention"
    end
    
    over_invested = goals.select { |g| g.priority_effort_gap&.< 0 }
    if over_invested.any?
      recs << "💡 Consider reallocating effort from #{over_invested.count} over-invested items"
    end
    
    if goals_by_risk(0).any?
      recs << "❓ Set priorities for #{goals_by_risk(0).count} undefined items"
    end

    recs
  end

  def empty_metrics
    {
      total_goals: 0,
      alignment_percentage: 0,
      critical_percentage: 0,
      total_effort_points: 0,
      total_priority_points: 0,
      average_gap: 0
    }
  end
end
