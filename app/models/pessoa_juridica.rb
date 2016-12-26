class PessoaJuridica < ApplicationRecord
  validates :cnpj, presence: true,
                   uniqueness: { case_insensitive: false },
                   numericality: { only_integer: true },
                   length: { is: 14 }

  validates :razao_social, presence: true,
                           uniqueness: true,
                           length: { in: 2..70 }

  validates :nome_fantasia, presence: true,
                            uniqueness: true,
                            length: { in: 2..70 }

  has_many :contas, as: :pessoa
end
