FactoryGirl.define do
  factory :pessoa_fisica do
    cpf { Faker::Number.number(11) }
    nome { Faker::Name.name }
    data_nascimento { Date.today.strftime('%Y-%m-%d') }

    factory :pessoa_fisica_invalida do
      id { 0 }
      cpf { Faker::Number.number(10) }
      nome { '' }
      data_nascimento { (DateTime.now + 1.day).strftime('%Y-%m-%d') }
    end
  end
end
