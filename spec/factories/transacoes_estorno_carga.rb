FactoryGirl.define do
  factory :transacao_estorno_carga, class: Transacao do
    tipo { 'estorno' }
    estornado { true }
    codigo_transacional_estornado { nil }

    trait :valida do
      after(:build) do |transacao_estorno_carga|
        transacao_carga_estornar = FactoryGirl.build(:transacao_carga).efetuar
        transacao_estorno_carga.codigo_transacional_estornado = transacao_carga_estornar.codigo_transacional
      end
    end

    trait :campos_completos do
      codigo_transacional { nil }
      conta_origem_id { nil }
      conta_origem_valor_antes_transacao { nil }

      after(:build) do |transacao_estorno_carga|
        transacao_carga_estornar = FactoryGirl.create(:transacao_carga, :campos_completos)
        conta = Conta.find(transacao_carga_estornar.conta_origem_id)

        codigo_transacional_estorno_carga =  TransacaoHelper::Gerador.codigo_alphanumerico(
            tipo: 'estorno', conta_origem_id: transacao_carga_estornar.conta_origem_id
        )

        transacao_estorno_carga.codigo_transacional = codigo_transacional_estorno_carga
        transacao_estorno_carga.valor = transacao_carga_estornar.valor
        transacao_estorno_carga.conta_origem_id = transacao_carga_estornar.conta_origem_id
        transacao_estorno_carga.conta_origem_valor_antes_transacao = conta.saldo
        transacao_estorno_carga.codigo_transacional_estornado = transacao_carga_estornar.codigo_transacional
      end
    end
  end
end
