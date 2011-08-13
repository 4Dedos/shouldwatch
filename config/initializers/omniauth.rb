Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, {:client_options => {:ssl => {:ca_path => "#{Rails.root}/lib/ca-bundle.crt"}}}
end

