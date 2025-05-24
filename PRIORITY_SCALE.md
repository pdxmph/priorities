# Priority Scale Design Decision

## The Problem

Most people expect priority scales to work like bug tracking systems:
- **P1 = High Priority** (critical, urgent)
- **P2 = Medium Priority** 
- **P3 = Low Priority**

But for gap analysis math to work intuitively, we need:
- **Higher numbers = Higher priority** (so 3 - 1 = 2 gap makes sense)

## The Solution: Display Layer

### Internal Storage (for math)
```ruby
priority: 3  # High priority (internal)
effort: 1    # Low effort
gap = 3 - 1 = 2  # Clear under-resourcing
```

### User Display (intuitive)
```ruby
goal.priority_display  # "P1 (High)"
goal.effort_display    # "Low effort" 
goal.alignment_narrative  # "Under-resourced (P1 (High), Low effort)"
```

### Form Options
```ruby
priority_select_options = [
  ['P1 (High Priority)', 3],    # User sees P1, stores 3
  ['P2 (Medium Priority)', 2],  # User sees P2, stores 2  
  ['P3 (Low Priority)', 1],     # User sees P3, stores 1
  ['Unset', 0]
]
```

## Benefits

1. **Math works**: `priority - effort` gives intuitive gaps
2. **Users see familiar P1/P2/P3** in UI
3. **Developers get clean logic** in code
4. **Backward compatible** with existing data

## Implementation

- `priority` field stores 0-3 (math-friendly)
- `priority_display()` shows "P1 (High)" etc (user-friendly)
- Forms use select options that map P1→3, P2→2, P3→1
- All displays use the intuitive scale
- Business logic uses the mathematical scale

This solves the "counter-intuitive numbering" problem while keeping the gap analysis math clean and understandable.

## Example Output

```
Launch new feature:
  Internal: Priority 3, Effort 1  
  Display: P1 (High), Low effort
  Gap: 2
  Status: ⚠️ Under-resourced (P1 (High), Low effort)
```

Perfect! Users see P1 priorities but the math still works.
