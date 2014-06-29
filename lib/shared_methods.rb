module SharedMethods
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  def goal_difference
    self.try(:team_a_score).to_i - self.try(:team_b_score).to_i
  end
  
  def save_options
    self.options = self.initialize_options
  end
  
  def initialize_options
    match = self.respond_to?(:final_stage?) ? self : self.match
    if match.final_stage?
      ['ft', 'et', 'so'].each { |name|
        options["#{name}_result"] = calculate_option_result(match, options, name)
      }
    end
    options
  end
  
  def calculate_option_result(match, options, name)
    teams = match.match.split('Vs')
    team_a_score = options["#{name}_score1"].to_i
    team_b_score = options["#{name}_score2"].to_i
    if team_a_score == team_b_score
      'Draw'
    elsif team_a_score > team_b_score
      teams[0].strip
    elsif team_a_score < team_b_score
      teams[1].strip
    end 
  end
  
  def calculate_draw_result(options, name)
    case name
    when 'et'
      options['ft_result'] == 'Draw' ? 'Draw' : '-' 
    when 'so'
      options['et_result'] == 'Draw' ? 'Draw' : '-' 
    else
      'Draw'
    end
  end
  
  def save_team_scores
    match = self.respond_to?(:final_stage?) ? self : self.match
    if match.final_stage? && !options.blank?
      self.team_a_score = calculate_team_score('score1')
      self.team_b_score = calculate_team_score('score2')
      self.result = calculate_result
    end
  end
  
  def calculate_team_score(score)
    ['ft', 'et', 'so'].inject(0) { |total, value| total += options["#{value}_#{score}"].to_i }
  end
  
  def calculate_result
    match = self.respond_to?(:final_stage?) ? self : self.match
    teams = match.match.split('Vs')
    if self.team_a_score == self.team_b_score
      'Draw'
    elsif self.team_a_score > self.team_b_score
      teams[0].strip
    elsif self.team_a_score < self.team_b_score
      teams[1].strip
    end
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