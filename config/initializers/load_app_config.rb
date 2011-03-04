
theme_config = File.read(Rails.root.to_s + "/config/theme.yml")
THEME_CONFIG = YAML.load(theme_config).symbolize_keys

SITE = Rails.env.production? ? THEME_CONFIG[:site_production_domain] : THEME_CONFIG[:site_development_domain]

SITE_FULL_NAME = THEME_CONFIG[:site_full_name]

GOOGLE_CHART_COLOUR_ARRAY = %w(3CD983 C4D925 BABF1B BFA20F A66D03 732C02)
SEX = ["Male","Female"]
USER_TYPE = ["Teacher","Guest"]
GROUPS = USER_TYPE + (1992..Date.today.year+1).to_a
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
NOTIFICATION_FIELDS = %w(news event message blog_comment
                          profile_comment follow delete_friend )
PERSONAL_INFO= %w(house_name blood_group date_of_birth address_line1 landline mobile relationship_status spouse_name aniversery_date professional_qualification about_me activities)
DEFAULT_PERMISSIONS = ["Myself", "Friends", "Everyone"]
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