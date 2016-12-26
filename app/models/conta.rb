class Conta < ApplicationRecord
  after_initialize :iniciar_saldo, if: :new_record?
  validate :validar_ancestry
  before_update :conta_cancelada_nao_recebe_atividade

  enum status: [:cancelado, :ativo, :bloqueado]

  validates :nome, presence: true,
                   uniqueness: true,
                   format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ },
                   length: { in: 2..70 }

  validates :saldo, presence: true,
                    numericality: true

  validates :status, presence: true,
                     inclusion: { in: Conta.statuses.keys }

  validates :pessoa, presence: true

  belongs_to :pessoa, polymorphic: true
  has_ancestry

  scope :transacoes, -> { Transacao.where('conta_origem_id = ? || conta_destino_id = ?', self.id, self.id) }

  def iniciar_saldo
    self.saldo = 0
    self.status = 'ativo'
  end

  def depositar(valor)
    return self unless valor_valido?(valor)

    self.saldo += valor
    self
  end

  def sacar(valor)
    unless valor <= self.saldo
      self.errors.add(:valor, message: 'deve ser maior ou igual ao saldo.')
      return self
    end

    self.saldo -= valor
    self
  end

  def sacar_estorno(valor)
    return self unless valor_valido?(valor)

    self.saldo -= valor
    self
  end

  def conta_valida?
    if self.status == 'cancelado' || self.status == 'bloqueado'
      errors.add(:conta, message: 'não pode ser transações ou cargas quando status for cancelado ou bloqueado.')
      false
    else
      true
    end
  end

  private
    def valor_valido?(valor)
      unless valor > 0
        errors.add(:valor, message: 'deve ser maior que 0.')
        return false
      end

      true
    end

    def validar_ancestry
      return true if ancestry.blank?

      conta_ancestry = Conta.find_by(id: self.ancestry.split('/').last)

      if conta_ancestry.blank?
        errors.add(:conta, message: 'conta ancestral não encontrada.')
        return false
      end

      if conta_ancestry.id == self.id
        errors.add(:conta, message: 'conta ancestral não pode ser a própria conta.')
        return false
      end

      if conta_ancestry.ancestor_ids.include?(self.id)
        errors.add(:conta, message: 'conta ancestral não pode ser sua descendente.')
        return false
      end

      self.parent = conta_ancestry
      true
    end

    def conta_cancelada_nao_recebe_atividade
      conta_antes_atualizacao = Conta.find_by(id: self.id)

      if conta_antes_atualizacao.status == 'cancelado'
        errors.add(:conta, message: 'conta cancelada não pode receber mais atividades.')
        return false
      end

      true
    end
end
