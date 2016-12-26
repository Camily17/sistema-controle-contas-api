FactoryGirl.define do
    factory :transacao_transferencia_matriz, class: TransacaoTransferencia do
    tipo { 'transferencia' }
    valor { '250' }
    conta_origem_id { nil}
    conta_destino_id { nil }
    estornado { nil }

    trait :valida do
      after(:build) do |transacao_transferencia_matriz|
        conta_destino_matriz = FactoryGirl.create(:conta_pessoa_fisica, saldo: 0)
        conta_origem_filial = FactoryGirl.create(:conta_pessoa_fisica, saldo: 1000, ancestry: conta_destino_matriz.id)
        transacao_transferencia_matriz.conta_origem_id = conta_origem_filial.id
        transacao_transferencia_matriz.conta_destino_id = conta_destino_matriz.id
      end
    end

    trait :campos_completos do
      codigo_transacional { nil }
      conta_origem_valor_antes_transacao { nil }
      conta_destino_valor_antes_transacao { nil }
      estornado { false }
      codigo_transacional_estornado { nil }

      after(:build) do |transacao_transferencia_matriz|
        conta_destino_matriz = FactoryGirl.create(:conta_pessoa_fisica, saldo: 0)
        conta_origem_filial = FactoryGirl.create(:conta_pessoa_fisica, saldo: 1000, ancestry: conta_destino_matriz.id)

        codigo_transacional =  TransacaoHelper::Gerador.codigo_alphanumerico(
            tipo: 'transferencia', conta_origem_id: conta_origem_filial.id, conta_destino_id: conta_destino_matriz.id
        )

        transacao_transferencia_matriz.codigo_transacional = codigo_transacional
        transacao_transferencia_matriz.conta_origem_id = conta_origem_filial.id
        transacao_transferencia_matriz.conta_origem_valor_antes_transacao = conta_origem_filial.saldo
        transacao_transferencia_matriz.conta_destino_id = conta_destino_matriz.id
        transacao_transferencia_matriz.conta_destino_valor_antes_transacao = conta_destino_matriz.saldo

      end
    end
  end
end
