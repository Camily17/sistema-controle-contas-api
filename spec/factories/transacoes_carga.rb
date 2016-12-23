FactoryGirl.define do
  conta_origem = FactoryGirl.create(:conta_pessoa_fisica, saldo: 0)
  codigo_transacional =  TransacaoHelper::Gerador.codigo_alphanumerico(
    tipo: 'carga', conta_origem_id: conta_origem.id
  )

  factory :transacao_carga, class: Transacao do
    tipo { 'carga' }
    valor { 500 }
    conta_origem_id { conta_origem.id }

    trait :campos_completos do
      codigo_transacional { codigo_transacional }
      conta_origem_valor_antes_transacao { conta_origem.saldo }
      conta_destino_id { nil }
      conta_destino_valor_antes_transacao { nil }
      estornado { false }
      codigo_transacional_estornado { nil }
    end

    trait :campos_invalidos do
      valor { -200 }
      conta_origem_id { nil }
    end
  end
end
