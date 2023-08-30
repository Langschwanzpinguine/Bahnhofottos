Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Probably not safe, but works :')
    resource '*', headers: :any, methods: [:get, :post]
  end
end