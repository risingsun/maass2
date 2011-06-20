Factory.define :work do |b|
  b.profile{|p| p.association(:profile)}
  b.occupation "trainee"
  b.industry "web design"
  b.company_name "rising sun tech"
  b.company_website "risingsuntech.com"
  b.job_description "developer"
end