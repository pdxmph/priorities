#!/usr/bin/env ruby

# Demo script to showcase the improved priority alignment logic
# Run this without Rails to see the core logic in action

class Goal
  attr_accessor :name, :priority, :effort

  def initialize(name:, priority: 0, effort: 0)
    @name = name
    @priority = priority
    @effort = effort
  end

  def priority_effort_gap
    return nil if priority.nil? || effort.nil? || priority == 0
    priority - effort
  end

  def alignment_risk
    gap = priority_effort_gap
    return 0 if gap.nil?
    
    case gap
    when 2..3 then 3     # Critical: High priority, very low effort
    when 1 then 2        # Warning: Some misalignment  
    when 0 then 1        # Good: Effort matches priority
    when -3..-1 then 1   # Good: Over-investing (not necessarily bad)
    end
  end

  def priority_display
    case priority
    when 0 then "Unset"
    when 1 then "P3 (Low)"
    when 2 then "P2 (Medium)" 
    when 3 then "P1 (High)"
    end
  end

  def effort_display
    case effort
    when 0 then "None"
    when 1 then "Low"
    when 2 then "Medium"
    when 3 then "High"
    end
  end

  def alignment_narrative
    gap = priority_effort_gap
    return "Unknown" if gap.nil?
    
    case gap
    when 2..3
      "⚠️ Under-resourced (#{priority_display}, #{effort_display} effort)"
    when 1
      "⚡ Needs attention (#{priority_display}, #{effort_display} effort)"
    when 0
      "✅ Well-aligned (#{priority_display}, #{effort_display} effort)"
    when -3..-1
      "📈 Over-invested (#{priority_display}, #{effort_display} effort)"
    end
  end
end

# Demo the improved logic
puts "🎯 Priority Alignment Demo"
puts "📝 Note: Internally we use 3=High, 1=Low for math to work"
puts "📱 But display shows intuitive P1=High, P3=Low to users\n\n"

goals = [
  Goal.new(name: "Launch new feature", priority: 3, effort: 1),
  Goal.new(name: "Fix critical bugs", priority: 3, effort: 3),
  Goal.new(name: "Write documentation", priority: 2, effort: 3),
  Goal.new(name: "Team building event", priority: 1, effort: 1),
  Goal.new(name: "Undefined priority", priority: 0, effort: 2)
]

goals.each do |goal|
  puts "#{goal.name}:"
  puts "  Internal: Priority #{goal.priority}, Effort #{goal.effort}"
  puts "  Display: #{goal.priority_display}, #{goal.effort_display} effort"
  puts "  Gap: #{goal.priority_effort_gap || 'N/A'}"
  puts "  Status: #{goal.alignment_narrative}"
  puts
end

# Summary analysis
critical = goals.select { |g| g.alignment_risk == 3 }
attention = goals.select { |g| g.alignment_risk == 2 }
aligned = goals.select { |g| g.alignment_risk == 1 }
unknown = goals.select { |g| g.alignment_risk == 0 }

puts "📊 Summary:"
puts "  🚨 Critical gaps: #{critical.count}"
puts "  ⚠️ Need attention: #{attention.count}"  
puts "  ✅ Well-aligned: #{aligned.count}"
puts "  ❓ Unknown: #{unknown.count}"

if critical.any?
  puts "\n🚨 Critical Issues:"
  critical.each { |g| puts "  - #{g.name}" }
end
