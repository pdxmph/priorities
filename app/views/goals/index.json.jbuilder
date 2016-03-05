json.array!(@goals) do |goal|
  json.extract! goal, :id, :name, :description, :team_id, :priority, :support, :effort
  json.url goal_url(goal, format: :json)
end
