FactoryGirl.define do
  factory :transacao_carga do
    tipo { 'carga' }
    valor { 500 }
    conta_origem_id { FactoryGirl.create(:conta_pessoa_fisica, saldo: 0).id }

    trait :campos_completos do
      codigo_transacional { nil }
      conta_origem_valor_antes_transacao { nil }
      conta_destino_id { nil }
      conta_destino_valor_antes_transacao { nil }
      estornado { false }
      codigo_transacional_estornado { nil }

      after(:build) do |transacao_carga|
        codigo_transacional =  TransacaoHelper::Gerador.codigo_alphanumerico(tipo: 'carga', conta_origem_id: transacao_carga.conta_origem_id)

        transacao_carga.codigo_transacional = codigo_transacional
        transacao_carga.conta_origem_valor_antes_transacao = transacao_carga.conta_origem.saldo
      end
    end

    trait :campos_invalidos do
      valor { -200 }
      conta_origem_id { nil }
    end
  end
end
