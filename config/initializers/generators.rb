Rails.application.config.generators do |g|
  g.test_framework false
  g.stylesheets false
  g.javascripts false
  g.helper false
  g.channel assets: false
end
