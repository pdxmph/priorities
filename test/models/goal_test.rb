require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  
  def setup
    @list = List.create(name: "Test List")
    @team = Team.create(name: "Test Team")
  end

  test "priority_effort_gap calculates correctly" do
    goal = Goal.new(name: "Test", priority: 3, effort: 1, list: @list)
    assert_equal 2, goal.priority_effort_gap
    
    goal = Goal.new(name: "Test", priority: 2, effort: 2, list: @list)
    assert_equal 0, goal.priority_effort_gap
    
    goal = Goal.new(name: "Test", priority: 1, effort: 3, list: @list)
    assert_equal -2, goal.priority_effort_gap
  end

  test "alignment_risk identifies under-resourced priorities" do
    goal = Goal.new(name: "Critical", priority: 3, effort: 1, list: @list)
    assert_equal 3, goal.alignment_risk  # Critical gap
    
    goal = Goal.new(name: "Warning", priority: 3, effort: 2, list: @list)
    assert_equal 2, goal.alignment_risk  # Some gap
    
    goal = Goal.new(name: "Good", priority: 2, effort: 2, list: @list)
    assert_equal 1, goal.alignment_risk  # Well aligned
    
    goal = Goal.new(name: "Over", priority: 1, effort: 3, list: @list)
    assert_equal 1, goal.alignment_risk  # Over-invested but not bad
  end

  test "handles nil values gracefully" do
    goal = Goal.new(name: "Incomplete", priority: nil, effort: 1, list: @list)
    assert_nil goal.priority_effort_gap
    assert_equal 0, goal.alignment_risk
    
    goal = Goal.new(name: "Zero priority", priority: 0, effort: 1, list: @list)
    assert_nil goal.priority_effort_gap
    assert_equal 0, goal.alignment_risk
  end

  test "alignment_narrative provides clear descriptions" do
    goal = Goal.new(name: "Test", priority: 3, effort: 1, list: @list)
    assert_includes goal.alignment_narrative, "Under-resourced"
    assert_includes goal.alignment_narrative, "High"
    assert_includes goal.alignment_narrative, "Low"
  end

  test "backward compatibility with health method" do
    goal = Goal.new(name: "Test", priority: 3, effort: 1, list: @list)
    assert_equal goal.alignment_risk, goal.health
  end

end
