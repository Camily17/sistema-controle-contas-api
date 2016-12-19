module API
  module V1
    class ContasController < ApplicationController
      before_action :set_conta, only: [:show, :update, :destroy]

      # GET /contas
      def index
        @contas = Conta.all

        render json: @contas, status: 200
      end

      # GET /contas/1
      def show
        render json: @conta, status: 200
      end

      # POST /contas
      def create
        @conta = Conta.new(conta_params)

        if @conta.save
          head 204, location: api_v1_conta_url(@conta.id)
        else
          render json: @conta.errors, status: 422
        end
      end

      # PATCH/PUT /contas/1
      def update
        if @conta.update(conta_params)
          render json: @conta, status: 200
        else
          render json: @conta.errors, status: 422
        end
      end

      # DELETE /contas/1
      def destroy
        @conta.destroy

        head 204
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_conta
        @conta = Conta.find(params[:id])

        rescue
          head 404
      end

      # Only allow a trusted parameter "white list" through.
      def conta_params
        params.require(:conta).permit(:nome, :saldo, :status, :pessoa_id, :pessoa_type)
      end
    end
  end
end
