class TransacaoTransferenciaService
  def initialize(transacao)
    @transacao = transacao
  end

  def efetuar
    return false unless transacao_de_transferencia_valida?

    begin
      ActiveRecord::Base.transaction do
        @transacao.conta_origem.sacar(@transacao.valor).save
        @transacao.conta_destino.depositar(@transacao.valor).save
        @transacao.save
      end

      raise unless @transacao.errors.messages.blank?
      @transacao
    rescue
      false
    end
  end

  private
    def transacao_de_transferencia_valida?
      @transacao.errors.add(:id, :not_blank, message: 'não pode ser fornecido.') if @transacao.id
      @transacao.errors.add(:id, :incosistent, message: 'não pode transferir para a mesma conta.') if @transacao.conta_destino_id == @transacao.conta_origem_id
      @transacao.errors.add(:conta_origem, :blank, message: 'deve estar presente.') unless @transacao.conta_origem_id
      @transacao.errors.add(:conta_destino, :blank, message: 'deve estar presente.') unless @transacao.conta_destino_id
      @transacao.errors.add(:estornado, :not_false, message: 'deve ser falso.') if @transacao.estornado
      @transacao.errors.add(:codigo_transacional_estornado, :not_blank, message: 'não pode ser fornecido.') if @transacao.codigo_transacional_estornado

      if @transacao.conta_origem_id && @transacao.conta_destino_id
        @transacao.errors.add(:contas, :not_hierarchical, message: 'não têm a mesma hierarquia.') if @transacao.conta_origem.root.id != @transacao.conta_destino.root.id
      end

      if @transacao.conta_destino_id
        @transacao.errors.add(:conta_destino, :matriz, message: 'é uma conta matriz não pode receber transferência.') if @transacao.conta_destino.root.id == @transacao.conta_destino.id
      end

      return true if @transacao.errors.messages.blank?
      false
    end
end