class TransacaoCargaService
  def initialize(transacao)
    @transacao = transacao
  end

  def efetuar
    return false unless transacao_de_carga_valida?

    begin
      ActiveRecord::Base.transaction do
        @transacao.conta_origem.depositar(@transacao.valor).save
        @transacao.save
      end

      raise unless @transacao.errors.messages.blank?
      true
    rescue
      @transacao.errors.messages.merge(@transacao.conta_origem.errors.messages)
      false
    end
  end

  private
    def transacao_de_carga_valida?
      @transacao.errors.add(:id, :not_blank, message: 'não pode ser fornecido.') if @transacao.id
      @transacao.errors.add(:conta_destino_id, :not_blank, message: 'não pode ser fornecido.') if @transacao.conta_destino_id
      @transacao.errors.add(:conta_destino_valor_antes_transacao, :not_blank, message: 'não pode ser fornecido.') if @transacao.conta_destino_valor_antes_transacao
      @transacao.errors.add(:estornado, :not_false, message: 'deve ser falso.') if @transacao.estornado
      @transacao.errors.add(:codigo_transacional_estornado, :not_blank, message: 'não pode ser fornecido.') if @transacao.codigo_transacional_estornado

      return true if @transacao.errors.messages.blank?
      false
    end
end