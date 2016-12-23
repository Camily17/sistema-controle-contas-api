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

  def efetuar
    return false if cadastrada?

    return false unless set_valores_padrao

    case self.tipo
      when 'carga' then TransacaoCargaService.new(self).efetuar
      when 'transferencia' then TransacaoTransferenciaService.new(self).efetuar
      when 'estorno' then TransacaoEstornoService.new(self).efetuar
      else
        self.errors.add(:tipo, :invalid, message: 'deve ser válido.')
        false
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
      self.estornado = false

      if self.tipo == 'estorno'
        set_transacao_estorno
      else
        self.conta_origem_valor_antes_transacao = self.conta_origem.saldo if conta_origem_id
        self.conta_destino_valor_antes_transacao = self.conta_destino.saldo if conta_destino_id
      end

      self.codigo_transacional = criar_codigo_transacional
    end

  def set_transacao_estorno
    self.conta_origem_id = self.conta_origem_valor_antes_transacao = self.conta_destino_id = self.conta_destino_valor_antes_transacao = nil

    unless self.codigo_transacional_estornado
      self.errors.add(:codigo_transacional_estornado, :blank, message: 'deve ser fornecido.')
      return false
    end

    @transacao_a_estornar = Transacao.find_by(codigo_transacional: self.codigo_transacional_estornado)

    if @transacao_a_estornar.blank?
      self.errors.add(:codigo_transacional_estornado, :invalid)
      return false
    end

    if @transacao_a_estornar.estornado == true
      self.errors.add(:estornado, :not_false, message: 'deve ser falso em transação a ser estornada.')
      return false
    end

    if @transacao_a_estornar.tipo == 'estorno'
      self.errors.add(:tipo, :invalid, message: 'não deve ser estornado em transação a ser estornada.')
      return false
    end

    self.valor = @transacao_a_estornar.valor
    self.conta_origem_id = @transacao_a_estornar.conta_origem_id
    self.conta_origem_valor_antes_transacao = @transacao_a_estornar.conta_origem.saldo if @transacao_a_estornar.conta_origem_id
    self.conta_destino_id = @transacao_a_estornar.conta_destino_id
    self.conta_destino_valor_antes_transacao = @transacao_a_estornar.conta_destino.saldo if @transacao_a_estornar.conta_destino_id
  end

    def criar_codigo_transacional
      TransacaoHelper::Gerador.codigo_alphanumerico(
        conta_origem_id: conta_origem_id, tipo: tipo, conta_destino_id: conta_destino_id
      )
    end
end
