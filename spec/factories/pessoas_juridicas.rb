FactoryGirl.define do
  factory :pessoa_juridica do
    cnpj { Faker::Number.number(14) }
    sequence(:razao_social,'a') { |l| Faker::Company.name + l }
    sequence(:nome_fantasia, 'a') { |l| Faker::Company.name + l }

    factory :pessoa_juridica_invalida do
      id { 0 }
      cnpj { Faker::Number.number(15) }
      razao_social { '' }
      nome_fantasia { '' }
    end
  end
end
