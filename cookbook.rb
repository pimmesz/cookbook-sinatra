require "csv"
require_relative "recipe"

class Cookbook
  attr_reader :recipes
  alias all recipes

  def initialize(csv_file)
    @csv_file = csv_file
    @recipes = []
    load_csv
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_csv
  end

  def load_csv
    CSV.foreach(@csv_file) do |recipe|
      load_recipe = Recipe.new(recipe[0], recipe[1], recipe[3] == "true")
      load_recipe.cooking_time = recipe[2]
      @recipes << load_recipe
    end
  end

  def save_csv
    CSV.open(@csv_file, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.cooking_time, recipe.done]
      end
    end
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_csv
  end

  def mark_as_done(index)
    @recipes[index].mark_as_done
    save_csv
  end
end
