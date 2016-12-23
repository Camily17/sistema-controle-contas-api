FactoryGirl.define do
  conta_destino_matriz = FactoryGirl.create(:conta_pessoa_fisica, saldo: 0)
  conta_origem_filial = FactoryGirl.create(:conta_pessoa_fisica, saldo: 1000, ancestry: conta_destino_matriz.id)

  codigo_transacional =  TransacaoHelper::Gerador.codigo_alphanumerico(
    tipo: 'transferencia', conta_origem_id: conta_origem_filial.id, conta_destino_id: conta_destino_matriz.id
  )

  factory :transacao_transferencia_matriz, class: Transacao do
    tipo { 'transferencia' }
    valor { '250' }
    conta_origem_id { conta_origem_filial.id }
    conta_destino_id { conta_destino_matriz.id }

    trait :campos_completos do
      codigo_transacional { codigo_transacional }
      conta_origem_valor_antes_transacao { conta_origem_filial.saldo }
      conta_destino_valor_antes_transacao { conta_destino_matriz.saldo }
      estornado { false }
      codigo_transacional_estornado { nil }
    end
  end
end
