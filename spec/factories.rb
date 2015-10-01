FactoryGirl.define do  factory :menu do
    name "MyString"
price "MyString"
image_url "MyString"
description "MyText"
  end
  factory :store do
    name "MyString"
description "MyText"
  end
  factory :identity do
    
  end

  factory :link do
    title "Testing Rails"
    url "http://testingrailsbook.com"
  end
end
