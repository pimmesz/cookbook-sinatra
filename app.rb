require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require 'nokogiri'
require 'open-uri'

require_relative 'cookbook'
require_relative 'scraper'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

csv_file   = File.join(__dir__, 'recipes.csv')
cookbook   = Cookbook.new(csv_file)

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  erb :index
end
get '/about' do
  erb :about
end
get '/list' do
  @cookbook_all = cookbook.all
  erb :list
end
get '/create' do
    name = @view.ask_name
    description = @view.ask_description
    recipe = Recipe.new(name, description, done = false)
    @cookbook.add_recipe(recipe)
    list
  erb :create
end
get '/destroy' do
    index = @view.ask_index
    @cookbook.remove_recipe(index)
  erb :destroy
end
get '/import_recipes' do
  user_ingredient = @view.ask_for_ingredient
    # url = "http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{user_ingredient}"
    # doc = Nokogiri::HTML(open(url), nil, 'utf-8')

    file = File.join(__dir__, 'strawberry.html')
    doc = Nokogiri::HTML(File.open(file), nil, 'utf-8')

    scraper = Scraper.new(doc)
    recipes = scraper.scrape(user_ingredient)
    # index = @view.ask_index
    if recipes.length > 0
      recipes.each_with_index do |recipe, index|
        puts "#{index + 1} - #{recipe.name}" unless index > 5
      end
      index = @view.ask_index
      @cookbook.add_recipe(recipes[index])
    else
      puts "No recipes found"
    end
  erb :import_recipes
end
get '/mark_as_done' do
    list
    index = @view.ask_index
    @cookbook.mark_as_done(index)
    list
  erb :mark_as_done
end
