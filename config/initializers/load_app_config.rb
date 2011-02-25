
theme_config = File.read(RAILS_ROOT + "/config/theme.yml")
THEME_CONFIG = YAML.load(theme_config).symbolize_keys

SITE = Rails.env.production? ? THEME_CONFIG[:site_production_domain] : THEME_CONFIG[:site_development_domain]

SITE_FULL_NAME = THEME_CONFIG[:site_full_name]

GOOGLE_CHART_COLOUR_ARRAY = %w(3CD983 C4D925 BABF1B BFA20F A66D03 732C02)

INDIA_STATES = [ "Andhra Pradesh",
  "Arunachal Pradesh",
  "Assam",
  "Andaman and Nicobar Islands",
  "Bihar",
  "Chandigarh",
  "Chhattisgarh",
  "Dadra and Nagar Haveli",
  "Daman and Diu",
  "Delhi",
  "Goa",
  "Gujarat",
  "Harayana",
  "Himachal Pradesh",
  "Jammu and Kashmir",
  "Jharkhand",
  "Karnataka",
  "Kerala",
  "Lakshadweep",
  "Madhya Pradesh",
  "Maharashtra",
  "Manipur",
  "Meghalaya",
  "Mizoram",
  "Nagaland",
  "Orissa",
  "Punjab",
  "Puducherry",
  "Rajasthan",
  "Sikkim",
  "Tamilnadu",
  "Tripura",
  "Uttarakhand",
  "Uttar Pradesh",
  "West Bengal"]