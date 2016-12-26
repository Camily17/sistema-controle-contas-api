class TransacaoEstorno < Transacao
  def efetuar
    return false if cadastrada?
    return false unless set_valores_padroes
    @transacao_a_estornar = Transacao.find_by(codigo_transacional: self.codigo_transacional_estornado)

    begin
      ActiveRecord::Base.transaction do
        case @transacao_a_estornar.tipo
          when 'carga' then
            return false unless transacao_de_estorno_carga_valida?
            efetuar_estorno_carga
          when 'transferencia' then
            return false unless transacao_de_estorno_transferencia_valida?
            efetuar_estorno_transferencia
          else
            @transacao_a_estornar.errors.add(:tipo, :valid, message: 'transação a estornar deve ter tipo válido.')
            return false
        end
      end

      raise unless self.errors.messages.blank? && @transacao_a_estornar.errors.messages.blank?
      self
    rescue
      self.errors.messages.merge!(@transacao_a_estornar.errors.messages)
      false
    end
  end

  private
    def set_valores_padroes
      self.estornado = false
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
      self.codigo_transacional = criar_codigo_transacional
    end

    def transacao_de_estorno_carga_valida?
      self.errors.add(:codigo_transacional_estornado, :blank, message: 'deve ser fornecido.') unless self.codigo_transacional_estornado
      self.errors.add(:id, :not_blank, message: 'não pode ser fornecido.') if self.id
      self.errors.add(:conta_origem, :blank, message: 'deve estar presente.') unless self.conta_origem_id
      self.errors.add(:estornado, :not_false, message: 'deve ser falso.') if self.estornado == 1

      return true if self.errors.messages.blank?
      false
    end

    def efetuar_estorno_carga
      @conta_origem = self.conta_origem
      @conta_origem.sacar(self.valor)

      @conta_origem.save if @conta_origem.errors.messages.blank?

      self.save

      @transacao_a_estornar.estornado = true
      @transacao_a_estornar.save
      self.errors.messages.merge!(@conta_origem.errors.messages)

    end

    def transacao_de_estorno_transferencia_valida?
      self.errors.add(:codigo_transacional_estornado, :blank, message: 'deve ser fornecido.') unless self.codigo_transacional_estornado
      self.errors.add(:id, :not_blank, message: 'não pode ser fornecido.') if self.id
      self.errors.add(:id, :incosistent, message: 'não pode transferir para a mesma conta.') if self.conta_origem_id == self.conta_destino_id
      self.errors.add(:conta_origem, :blank, message: 'deve estar presente.') unless self.conta_origem_id
      self.errors.add(:conta_destino, :blank, message: 'deve estar presente.') unless self.conta_destino_id
      self.errors.add(:estornado, :not_false, message: 'deve ser falso.') if self.estornado == 1

      return true if self.errors.messages.blank?
      false
    end

    def efetuar_estorno_transferencia
      self.conta_destino.sacar(self.valor).save
      self.conta_origem.depositar(self.valor).save
      self.save

      @transacao_a_estornar.estornado = true
      @transacao_a_estornar.save
    end
end