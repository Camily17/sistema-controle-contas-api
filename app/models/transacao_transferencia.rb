class TransacaoTransferencia < Transacao
  def efetuar
    return false if cadastrada?
    return false unless set_valores_padroes
    return false unless transacao_valida?

    begin
      ActiveRecord::Base.transaction do
        self.conta_origem.sacar(self.valor).save
        self.conta_destino.depositar(self.valor).save
        self.save
      end

      raise unless self.errors.messages.blank?
      self
    rescue
      false
    end
  end

  private
    def set_valores_padroes
      self.estornado = false
      self.conta_origem_valor_antes_transacao = self.conta_origem.saldo if conta_origem_id
      self.conta_destino_valor_antes_transacao = self.conta_destino.saldo if conta_destino_id
      self.codigo_transacional = criar_codigo_transacional
    end

    def transacao_valida?
      self.errors.add(:id, :not_blank, message: 'não pode ser fornecido.') if self.id
      self.errors.add(:id, :incosistent, message: 'não pode transferir para a mesma conta.') if self.conta_destino_id == self.conta_origem_id
      self.errors.add(:conta_origem, :blank, message: 'deve estar presente.') unless self.conta_origem_id
      self.errors.add(:conta_destino, :blank, message: 'deve estar presente.') unless self.conta_destino_id
      self.errors.add(:estornado, :not_false, message: 'deve ser falso.') if self.estornado
      self.errors.add(:codigo_transacional_estornado, :not_blank, message: 'não pode ser fornecido.') if self.codigo_transacional_estornado

      if self.conta_origem_id && self.conta_destino_id
        self.errors.add(:contas, :not_hierarchical, message: 'não têm a mesma hierarquia.') if self.conta_origem.root.id != self.conta_destino.root.id
      end

      if self.conta_destino_id
        self.errors.add(:conta_destino, :matriz, message: 'é uma conta matriz não pode receber transferência.') if self.conta_destino.root.id == self.conta_destino.id
      end

      return true if self.errors.messages.blank?
      false
    end
end