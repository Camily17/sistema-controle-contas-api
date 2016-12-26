class TransacaoCarga < Transacao
  def efetuar
    return false if cadastrada?
    return false unless set_valores_padroes
    return false unless transacao_valida?

    begin
      ActiveRecord::Base.transaction do
        self.conta_origem.depositar(self.valor).save
        self.save
      end

      raise unless self.errors.messages.blank?
      self
    rescue
      self.errors.messages.merge(self.conta_origem.errors.messages)
      false
    end
  end

  private
    def set_valores_padroes
      self.estornado = false
      self.conta_origem_valor_antes_transacao = self.conta_origem.saldo if conta_origem_id
      self.codigo_transacional = criar_codigo_transacional
    end

    def transacao_valida?
      self.errors.add(:id, :not_blank, message: 'não pode ser fornecido.') if self.id
      self.errors.add(:conta_destino_id, :not_blank, message: 'não pode ser fornecido.') if self.conta_destino_id
      self.errors.add(:conta_destino_valor_antes_transacao, :not_blank, message: 'não pode ser fornecido.') if self.conta_destino_valor_antes_transacao
      self.errors.add(:estornado, :not_false, message: 'deve ser falso.') if self.estornado
      self.errors.add(:codigo_transacional_estornado, :not_blank, message: 'não pode ser fornecido.') if self.codigo_transacional_estornado
      self.errors.add(:conta_origem, :not_active, message: 'deve ter status ativo.') unless self.conta_origem.conta_valida?

      return true if self.errors.messages.blank?
      false
    end
end