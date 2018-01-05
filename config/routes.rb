Rails.application.routes.draw do
  root 'static#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/scrape_nike', to: 'scrape#scrape_nike'
  get '/scrape_wiki', to: 'scrape#scrape_wiki'
end
