module API
  module V1
    class TransacoesController < ApplicationController
      before_action :set_transacao, only: [:show]

      # GET /transacoes
      def index
        @transacoes = Transacao.all

        render json: @transacoes, status: 200
      end

      # GET /transacoes/1
      def show
        render json: @transacao, status: 200
      end

      # POST /transacoes
      def create
        case params[:transacao][:tipo]
          when 'carga' then @transacao = TransacaoCarga.new(transacao_params_carga)
          when 'transferencia' then @transacao = TransacaoTransferencia.new(transacao_params_transferencia)
          when 'estorno' then @transacao = TransacaoEstorno.new(transacao_params_estorno)
          else
            @transacao = OpenStruct.new(errors: ({tipo: [{message: 'deve ser válido'}]}).to_json, efetuar: false)
        end

        if @transacao.efetuar
          head 204, location: api_v1_transacao_url(@transacao.id)
        else
          render json: @transacao.errors, status: 422
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_transacao
        @transacao = Transacao.find(params[:id])
      rescue
        head 404
      end

      def get_conta
        @conta = Conta.find(params[:conta_id])
      end

      # Only allow a trusted parameter "white list" through.
      def transacao_params
        params.require(:transacao).permit(
            :tipo, :valor, :conta_origem_id, :conta_destino_id,
            :estornado, :condigo_transacional_estornado
        )
      end

      def transacao_params_carga
        params.require(:transacao).permit(:tipo, :valor, :conta_origem_id)
      end

      def transacao_params_transferencia
        params.require(:transacao).permit(:tipo, :valor, :conta_origem_id, :conta_destino_id)
      end

      def transacao_params_estorno
        params.require(:transacao).permit(:tipo, :codigo_transacional_estornado)
      end
    end
  end
end
