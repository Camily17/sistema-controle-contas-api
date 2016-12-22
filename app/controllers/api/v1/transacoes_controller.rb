module API
  module V1
    class TransacoesController < ApplicationController
      before_action :set_transacao, only: [:show]

      # GET /transacoes
      def index
        @transacoes = Transacao.includes(:contas).where('conta_origem_id = ? OR conta_destino_id = ?', transacao_params[:conta_origem_id], transacao_params[:conta_destino_id])

        render json: @transacoes, status: 200
      end

      # GET /transacoes/1
      def show
        render json: @transacao, status: 200
      end

      # POST /transacoes
      def create
        @transacao = Transacao.new(transacao_params)

        if @transacao.efetuar
          head 204, location: @transacao
        else
          render json: @transacao.errors, status: 422
        end
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_transacao
        @transacao = Transacao.includes(:contas).where('conta_origem_id = ? OR conta_destino_id = ?, id = ?', transacao_params[:conta_origem_id], transacao_params[:conta_destino_id] ,params[:id])

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
    end
  end
end
