module SharedMethods
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  def goal_difference
    self.try(:team_a_score) - self.try(:team_b_score)
  end
  
end

module ClassMethods
  def by_scoped(column, value)
    if value.blank?
      scoped
    else
      where(column.to_sym => value)
    end
  end
end