FactoryGirl.define do
  factory :transacao_estorno_transferencia, class: Transacao do
    tipo { 'estorno' }
    estornado { true }
    codigo_transacional_estornado { nil }

    trait :valida do
      after(:build) do |transacao_estorno_transferencia|
        transacao_transferencia_estornar = FactoryGirl.build(:transacao_transferencia_hierarquia, :igual).efetuar
        transacao_estorno_transferencia.codigo_transacional_estornado = transacao_transferencia_estornar.codigo_transacional
      end
    end

    trait :campos_completos do
      codigo_transacional { nil }
      conta_origem_id { nil }
      conta_origem_valor_antes_transacao { nil }

      after(:build) do |transacao_estorno_transferencia|
        transacao_transferencia_estornar = FactoryGirl.create(:transacao_transferencia_hierarquia, :campos_completos)
        conta_origem = Conta.find(transacao_transferencia_estornar.conta_origem_id)
        conta_destino = Conta.find(transacao_transferencia_estornar.conta_destino_id)

        codigo_transacional_estorno_carga =  TransacaoHelper::Gerador.codigo_alphanumerico(
            tipo: 'estorno', conta_origem_id: transacao_transferencia_estornar.conta_origem_id, conta_destino_id: transacao_transferencia_estornar.conta_destino_id
        )

        transacao_estorno_transferencia.codigo_transacional = codigo_transacional_estorno_carga
        transacao_estorno_transferencia.valor = transacao_transferencia_estornar.valor
        transacao_estorno_transferencia.conta_origem_id = transacao_transferencia_estornar.conta_origem_id
        transacao_estorno_transferencia.conta_origem_valor_antes_transacao = conta_origem.saldo
        transacao_estorno_transferencia.conta_destino_id = transacao_transferencia_estornar.conta_destino_id
        transacao_estorno_transferencia.conta_destino_valor_antes_transacao = conta_destino.saldo
        transacao_estorno_transferencia.codigo_transacional_estornado = transacao_transferencia_estornar.codigo_transacional
      end
    end
  end
end
