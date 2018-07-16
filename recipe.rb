class Recipe
  attr_reader :name, :description, :done
  attr_accessor :cooking_time, :detail
  def initialize(name, description, done)
    @name = name
    @description = description
    @cooking_time = nil
    @detail = nil
    @done = done
  end

  def mark_as_done
    @done = true
  end
end
