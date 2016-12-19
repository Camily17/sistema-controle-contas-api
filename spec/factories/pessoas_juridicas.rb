FactoryGirl.define do
  factory :pessoa_juridica do
    cnpj { Faker::Number.number(14) }
    razao_social { Faker::Company.name }
    nome_fantasia { Faker::Company.name }

    factory :pessoa_juridica_invalida do
      id { 0 }
      cnpj { Faker::Number.number(15) }
      razao_social { '' }
      nome_fantasia { '' }
    end
  end
end
