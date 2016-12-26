FactoryGirl.define do
  factory :transacao_transferencia_hierarquia, class: TransacaoTransferencia do
    tipo { 'transferencia' }
    valor { '250' }
    conta_origem_id { nil }
    conta_destino_id { nil }
    estornado { nil }

    trait :igual do
      conta_origem_id { nil }
      conta_destino_id { nil }

      after(:build) do |transacao_transferencia_hierarquia|
        conta_origem_hierarquia_igual = FactoryGirl.create(:conta_pessoa_fisica, saldo: 1000)
        conta_destino_hierarquia_igual = FactoryGirl.create(:conta_pessoa_fisica, saldo: 0, ancestry: conta_origem_hierarquia_igual.id)
        transacao_transferencia_hierarquia.conta_origem_id = conta_origem_hierarquia_igual.id
        transacao_transferencia_hierarquia.conta_destino_id = conta_destino_hierarquia_igual.id
      end
    end

    trait :diferente do
      conta_origem_id { FactoryGirl.create(:conta_pessoa_fisica, saldo: 1000).id }
      conta_destino_id { FactoryGirl.create(:conta_pessoa_fisica, saldo: 0).id }
    end

    trait :campos_completos do
      codigo_transacional { nil }
      conta_origem_valor_antes_transacao { nil }
      conta_destino_valor_antes_transacao { nil }
      estornado { false }
      codigo_transacional_estornado { nil }

      after(:build) do |transacao_transferencia_hierarquia|
        conta_origem_hierarquia_igual = FactoryGirl.create(:conta_pessoa_fisica, saldo: 1000)
        conta_destino_hierarquia_igual = FactoryGirl.create(:conta_pessoa_fisica, saldo: 0, ancestry: conta_origem_hierarquia_igual.id)

        codigo_transacional_hierarquia_igual =  TransacaoHelper::Gerador.codigo_alphanumerico(
            tipo: 'transferencia', conta_origem_id: conta_origem_hierarquia_igual.id, conta_destino_id: conta_destino_hierarquia_igual.id
        )

        transacao_transferencia_hierarquia.codigo_transacional = codigo_transacional_hierarquia_igual
        transacao_transferencia_hierarquia.conta_origem_id = conta_origem_hierarquia_igual.id
        transacao_transferencia_hierarquia.conta_origem_valor_antes_transacao = conta_origem_hierarquia_igual.saldo
        transacao_transferencia_hierarquia.conta_destino_id = conta_destino_hierarquia_igual.id
        transacao_transferencia_hierarquia.conta_destino_valor_antes_transacao = conta_destino_hierarquia_igual.saldo
      end
    end
  end
end
