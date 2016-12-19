FactoryGirl.define do
  factory :pessoa_fisica do
    cpf { Faker::Number.number(11) }
    nome { Faker::Name.name }
    data_nascimento { Date.today }

    factory :pessoa_fisica_invalida do
      cpf { Faker::Number.number(10) }
      nome { '' }
      data_nascimento { (DateTime.now + 1.day) }
    end
  end
end
