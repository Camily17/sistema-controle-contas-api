class Transacao < ApplicationRecord
  enum tipo: [:carga, :transferencia, :estornar]

  validates :codigo_transacional, presence: true,
            uniqueness: true,
            length: { is: 32 }

  validates :tipo, presence: true,
            inclusion: { in: Transacao.tipos.keys }

  validates :valor, presence: true,
                    numericality: { greater_than: 0 }

  validates :conta_origem_id, presence: true,
                              numericality: true

  validates :conta_origem_valor_antes_transacao, presence: true,
                                                 numericality: { greater_than_or_equal_to: 0 }

  validates :conta_destino_id, numericality: true,
                              allow_nil: { if: Proc.new { |t| t.tipo == 'carga' } }

  validates :conta_destino_valor_antes_transacao, numericality: { greater_than_or_equal_to: 0 }, allow_nil: { if: Proc.new { |t| t.conta_destino_id.nil? } }

  validates :estornado, inclusion: { in: [true, false] }

  validates :codigo_transacional_estornado, uniqueness: true, length: { is: 32 }, allow_nil: { if: Proc.new { |t| t.estornado == true } }

  validates_associated :conta_destino, :conta_origem

  belongs_to :conta_origem, class_name: 'Conta', foreign_key: 'conta_origem_id'
  belongs_to :conta_destino, class_name: 'Conta', foreign_key: 'conta_destino_id'

  def contas
    Conta.where(id: [self.conta_origem_id, self.conta_destino_id])
  end

  def efetuar
    return false if cadastrada?

    set_valores_padrao

    case self.tipo
      when 'carga' then TransacaoCargaService.new(self).efetuar
      when 'transferencia' then TransacaoTransferenciaService.new(self).efetuar
      else false
    end
  end

  def cadastrada?
    if Transacao.find_by(codigo_transacional: self.codigo_transacional)
      self.errors.add(:codigo_transacional, message: 'já está cadastrado cadastrado')
      return true
    end

    false
  end

  private
    def set_valores_padrao
      self.conta_origem_valor_antes_transacao = self.conta_origem.saldo if conta_origem_id
      self.conta_destino_valor_antes_transacao = self.conta_destino.saldo if conta_destino_id
      self.estornado = false
      self.codigo_transacional = criar_codigo_transacional
    end

    def criar_codigo_transacional
      TransacaoHelper::Gerador.codigo_alphanumerico(
        conta_origem_id: conta_origem_id, tipo: tipo, conta_destino_id: conta_destino_id
      )
    end
end
