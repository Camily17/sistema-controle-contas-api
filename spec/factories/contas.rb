FactoryGirl.define do
  factory :conta do
    nome { Faker::Name.name }
    saldo { 0 }
    status { 1 }

    factory :conta_pessoa_fisica do
      pessoa_type { 'PessoaFisica' }
      pessoa_id { FactoryGirl.create(:pessoa_fisica).id }
    end

    factory :conta_pessoa_juridica do
      pessoa_type { 'PessoaFisica' }
      pessoa_id { FactoryGirl.create(:pessoa_juridica).id }
    end

    factory :conta_invalida do
      id { 0 }
      nome { '' }
      saldo { -10 }
      status { 2 }

      factory :conta_invalida_pessoa_fisica do
        pessoa_type { 'PessoaFisica' }
        pessoa_id { FactoryGirl.attributes_for(:pessoa_fisica_invalida)[:id] }
      end

      factory :conta_invalida_pessoa_juridica do
        pessoa_type { 'PessoaFisica' }
        pessoa_id { FactoryGirl.attributes_for(:pessoa_juridica_invalida)[:id] }
      end
    end
  end
end
