class Conta < ApplicationRecord
  after_initialize :iniciar_saldo

  enum status: ['cancelado', 'ativo', 'bloqueado']

  validates :nome, presence: true,
                   uniqueness: true,
                   format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ },
                   length: { in: 2..70 }

  validates :saldo, presence: true,
                    numericality: true

  validates :status, presence: true,
                     inclusion: { in: Conta.statuses.keys }

  validates :pessoa_type, presence: true
  validates :pessoa_id, presence: true

  belongs_to :pessoa, polymorphic: true
  has_ancestry

  def transacoes
    Transacao.where('conta_origem_id = ? || conta_destino_id = ?', self.id, self.id)
  end

  def iniciar_saldo
    self.saldo = 0
    self.status = 'ativo'
  end

  def depositar(valor)
    unless valor > 0
      errors.add(:valor, message: 'deve ser maior que 0.')
      return self
    end

    self.saldo += valor

    self
  end

  def sacar(valor)
    unless valor >= @saldo
      errors.add(:valor, message: 'deve ser maior ou igual ao saldo.')
      return self
    end

    self.saldo -= valor

    self
  end
end
