class TransacaoEstornoService
  def initialize(transacao)
    @transacao = transacao
  end

  def efetuar
    @transacao_a_estornar = Transacao.find_by(codigo_transacional: @transacao.codigo_transacional_estornado)

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
        raise unless @transacao.errors.messages.blank? && @transacao_a_estornar.errors.messages.blank?
        true
      end
    rescue => e
      p e
      @transacao.errors.messages.merge!(@transacao_a_estornar.errors.messages)
      false
    end
  end

  private
    def transacao_de_estorno_carga_valida?
      @transacao.errors.add(:codigo_transacional_estornado, :blank, message: 'deve ser fornecido.') unless @transacao.codigo_transacional_estornado
      @transacao.errors.add(:id, :not_blank, message: 'não pode ser fornecido.') if @transacao.id
      @transacao.errors.add(:conta_origem, :blank, message: 'deve estar presente.') unless @transacao.conta_origem_id
      @transacao.errors.add(:estornado, :not_false, message: 'deve ser falso.') if @transacao.estornado == 1

      return true if @transacao.errors.messages.blank?
      false
    end

    def efetuar_estorno_carga
      @conta_origem = @transacao.conta_origem
      @conta_origem.sacar(@transacao.valor)

      @conta_origem.save if @conta_origem.errors.messages.blank?

      @transacao.save

      @transacao_a_estornar.estornado = true
      @transacao_a_estornar.save
      @transacao.errors.messages.merge!(@conta_origem.errors.messages)

    end

    def transacao_de_estorno_transferencia_valida?
      @transacao.errors.add(:codigo_transacional_estornado, :blank, message: 'deve ser fornecido.') unless @transacao.codigo_transacional_estornado
      @transacao.errors.add(:id, :not_blank, message: 'não pode ser fornecido.') if @transacao.id
      @transacao.errors.add(:id, :incosistent, message: 'não pode transferir para a mesma conta.') if @transacao.conta_origem_id == @transacao.conta_destino_id
      @transacao.errors.add(:conta_origem, :blank, message: 'deve estar presente.') unless @transacao.conta_origem_id
      @transacao.errors.add(:conta_destino, :blank, message: 'deve estar presente.') unless @transacao.conta_destino_id
      @transacao.errors.add(:estornado, :not_false, message: 'deve ser falso.') if @transacao.estornado == 1

      return true if @transacao.errors.messages.blank?
      false
    end

    def efetuar_estorno_transferencia
      @transacao.conta_destino.sacar(@transacao.valor).save
      @transacao.conta_origem.depositar(@transacao.valor).save
      @transacao.save

      @transacao_a_estornar.estornado = true
      @transacao_a_estornar.save
    end
end