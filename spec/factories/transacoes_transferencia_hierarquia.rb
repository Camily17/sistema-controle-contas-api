FactoryGirl.define do
  conta_origem_hierarquia_igual = FactoryGirl.create(:conta_pessoa_fisica, saldo: 1000)
  conta_destino_hierarquia_igual = FactoryGirl.create(:conta_pessoa_fisica, saldo: 0, ancestry: conta_origem_hierarquia_igual.id)
  codigo_transacional_hierarquia_igual =  TransacaoHelper::Gerador.codigo_alphanumerico(
      tipo: 'transferencia', conta_origem_id: conta_origem_hierarquia_igual.id, conta_destino_id: conta_destino_hierarquia_igual.id
  )

  conta_origem_hierarquia_diferente = FactoryGirl.create(:conta_pessoa_fisica, saldo: 1000)
  conta_destino_hierarquia_diferente = FactoryGirl.create(:conta_pessoa_fisica, saldo: 0)

  factory :transacao_transferencia_hierarquia, class: Transacao do
    tipo { 'transferencia' }
    valor { '250' }
    conta_origem_id { conta_origem_hierarquia_igual.id }
    conta_destino_id { conta_destino_hierarquia_igual.id }

    trait :campos_completos do
      codigo_transacional { codigo_transacional_hierarquia_igual }
      conta_origem_valor_antes_transacao { conta_origem_hierarquia_igual.saldo }
      conta_destino_valor_antes_transacao { conta_destino_hierarquia_igual.saldo }
      estornado { false }
      codigo_transacional_estornado { nil }
    end

    trait :diferente do
      conta_origem_id { conta_origem_hierarquia_diferente.id }
      conta_destino_id { conta_destino_hierarquia_diferente.id }
    end
  end
end
