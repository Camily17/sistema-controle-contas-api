class Transacao < ApplicationRecord
  enum tipo: [:carga, :transferencia, :estorno]

  validates :codigo_transacional, presence: true,
            uniqueness: true,
            length: { is: 32 }

  validates :tipo, presence: true,
            inclusion: { in: Transacao.tipos.keys }

  validates :valor, presence: true,
                    numericality: { greater_than: 0 }

  validates :conta_origem_id, presence: true,
                              numericality: { only_integer: true }

  validates :conta_origem_valor_antes_transacao, presence: true,
                                                 numericality: { greater_than_or_equal_to: 0 }

  validates :conta_destino_id, numericality: { only_integer: true },
                              allow_nil: { if: Proc.new { |t| t.tipo == 'carga' } }

  validates :conta_destino_valor_antes_transacao, numericality: { greater_than_or_equal_to: 0 }, allow_nil: { if: Proc.new { |t| t.conta_destino_id.nil? } }

  validates :codigo_transacional_estornado, uniqueness: true, length: { is: 32 }, allow_nil: { if: Proc.new { |t| t.estornado == true } }

  belongs_to :conta_origem, class_name: 'Conta', foreign_key: 'conta_origem_id'
  belongs_to :conta_destino, class_name: 'Conta', foreign_key: 'conta_destino_id'

  def contas
    Conta.where(id: [self.conta_origem_id, self.conta_destino_id])
  end

  def efetuar; end

  private
    def cadastrada?
      if Transacao.find_by(codigo_transacional: self.codigo_transacional)
        self.errors.add(:codigo_transacional, message: 'já está cadastrado cadastrado')
        return true
      end
      false
    end

    def set_valores_padroes; end

    def criar_codigo_transacional
      TransacaoHelper::Gerador.codigo_alphanumerico(
        conta_origem_id: conta_origem_id, tipo: tipo, conta_destino_id: conta_destino_id
      )
    end
end
