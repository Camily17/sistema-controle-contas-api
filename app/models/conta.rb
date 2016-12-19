class Conta < ApplicationRecord
  enum status: ['cancelado', 'ativo', 'bloqueado']

  validates :nome, presence: true,
                   uniqueness: true,
                   format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ },
                   length: { in: 2..70 }

  validates :saldo, presence: true,
                    numericality: true

  validates :status, presence: true

            validates_inclusion_of :status, in: Conta.statuses.keys

  validates :pessoa_type, presence: true
  validates :pessoa_id, presence: true

  belongs_to :pessoa, polymorphic: true
end
