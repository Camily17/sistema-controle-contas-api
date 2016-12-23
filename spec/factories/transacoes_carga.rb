FactoryGirl.define do
  factory :transacao_carga, class: Transacao do
    codigo_transacional { '' }
    tipo { 'carga' }
    valor { '500' }
    conta_origem_id { nil }
    conta_origem_valor_antes_transacao { nil }
    conta_destino_id { nil }
    conta_destino_valor_antes_transacao { nil }
    estornado { false }
    codigo_transacional_estornado { nil }

    factory :transacao_carga_invalida do
      codigo_transacional { '' }
      tipo { '' }
      valor { nil }
      conta_origem_id { nil }
      conta_origem_valor_antes_transacao { nil }
      conta_destino_id { nil }
      conta_destino_valor_antes_transacao { nil }
      estornado { false }
      codigo_transacional_estornado { nil }
    end
  end

  factory :transacao_carga_atributos_validos, class: Transacao do
    tipo  { 'carga' }
    valor { '500' }
    conta_origem_id { nil }

    factory :transacao_carga_atributos_invalidos, class: Transacao do
      tipo { 'carga' }
      valor { -500 }
      conta_origem_id { nil }
    end
  end
end
