class Scraper
  def initialize(doc)
    @doc = doc
  end

  def scrape(user_ingredient)
    recipes = []
    @doc.search('.m_contenu_resultat').each do |recipe|
      next if !recipe.search('.m_texte_resultat').text.strip.include?(user_ingredient)
      name = recipe.search('.m_titre_resultat').text.strip
      description = recipe.search('.m_texte_resultat').text.strip
      new_recipe = Recipe.new(name, description, done = false)
      new_recipe.detail = recipe.search('.m_detail_recette').text.strip
      new_recipe.cooking_time = recipe.search('.m_prep_time').first.parent.text.strip
      recipes << new_recipe
    end
    return recipes
  end
end
