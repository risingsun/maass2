
theme_config = File.read(Rails.root.to_s + "/config/theme.yml")
THEME_CONFIG = YAML.load(theme_config).symbolize_keys

SITE = Rails.env.production? ? THEME_CONFIG[:site_production_domain] : THEME_CONFIG[:site_development_domain]

SITE_FULL_NAME = THEME_CONFIG[:site_full_name]
SITE_NAME = THEME_CONFIG[:site_name]
GOOGLE_CHART_COLOUR_ARRAY = %w(3CD983 C4D925 BABF1B BFA20F A66D03 732C02)
SEX = ["Male","Female"]
BLOOD_GROUP = ["A+","A-","B+","B-","AB+","AB-","O+","O-"]
TITLE = ["Ms.","Mr.","Mrs.","Dr.","Er.","Lt.","Capt.","Col.","Maj.","Prof.","Advct."]
EDU_YEAR=(1990..Date.today.year+5).to_a
RELATIONSHIP_STATUS =  ["single","Married","not sure"]
HOUSE_NAME = ["Bharat","Eklavya","Prahalad","Shravan"]
PERMISSION_FIELDS = %w(website blog about_me gtalk_name location email
                         date_of_birth anniversary_date relationship_status
                         spouse_name gender activities yahoo_name skype_name
                         educations work_informations delicious_name
                         twitter_username msn_username linkedin_name
                         address landline mobile marker)
PERSONAL_INFO= %w(house_name blood_group date_of_birth address_line1 landline mobile relationship_status spouse_name aniversery_date professional_qualification about_me activities)

RESULTS_PER_PAGE = THEME_CONFIG[:results_per_page]
PROFILE_PER_PAGE = THEME_CONFIG[:profile_per_page]
POLLS_ON_PROFILE = THEME_CONFIG[:polls_on_profile]
POLLS_PER_PAGE = THEME_CONFIG[:polls_per_page]
BLOGS_ON_PROFILE = THEME_CONFIG[:blogs_on_profile]
BLOGS_PER_PAGE = THEME_CONFIG[:blogs_per_page]
BLOGS_ON_HOME_PAGE = THEME_CONFIG[:blogs_on_home_page]

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

SEARCH_KEYS = ['name','location','blood_group','year','blog','phone','address']

BATCH_RANGE = THEME_CONFIG[:batch_start]..(Date.today.year + 1)
DISABLE_STUDENT_CHECKING = !!THEME_CONFIG[:student_checking]
USER_TYPE = THEME_CONFIG[:user_types].map{|x|[x]}
GROUPS = USER_TYPE + BATCH_RANGE.to_a.map{|x|[x.to_s]}

MAILER_FROM_ADDRESS = THEME_CONFIG[:mailer_from_address]

smtp_settings = THEME_CONFIG[:smtp_settings].symbolize_keys
ActionMailer::Base.smtp_settings = {
  :address => smtp_settings[:address],
  :port => smtp_settings[:port],
  :domain => smtp_settings[:domain],
  :authentication => smtp_settings[:authentication].to_sym,
  :user_name => smtp_settings[:user_name],
  :password => smtp_settings[:password]
}