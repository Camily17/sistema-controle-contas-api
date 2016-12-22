FactoryGirl.define do
  factory :transacao do
    condigo_transacional "MyString"
    tipo 1
    valor "9.99"
    conta_origem_id 1
    conta_origem_valor_antes_transacao "9.99"
    conta_destino_id 1
    conta_destino_valor_antes_transacao "9.99"
    estornado false
    condigo_transacional_estornado ""
  end
end
