class PessoaFisica < ApplicationRecord
  validates :cpf, presence: true,
                  uniqueness: { case_insensitive: false },
                  numericality: { only_integer: true },
                  length: { is: 11 }


  validates :nome, presence: true,
                   format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/ },
                   length: { in: 2..70 }

  validates :data_nascimento, presence: true
  validates_date :data_nascimento, on_or_before: -> { Date.today }

  has_many :contas, as: :pessoa
end
