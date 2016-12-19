module API
  module V1
    class PessoasJuridicasController < ApplicationController
      before_action :set_pessoa_juridica, only: [:show, :update, :destroy]

      # GET /pessoas_juridicas
      def index
        @pessoas_juridicas = PessoaJuridica.all

        render json: @pessoas_juridicas, status: 200
      end

      # GET /pessoas_juridicas/1
      def show
        render json: @pessoa_juridica, status: 200
      end

      # POST /pessoas_juridicas
      def create
        @pessoa_juridica = PessoaJuridica.new(pessoa_juridica_params)

        if @pessoa_juridica.save
          head 204, location: api_v1_pessoa_juridica_url(@pessoa_juridica.id)
        else
          render json: @pessoa_juridica.errors, status: 422
        end
      end

      # PATCH/PUT /pessoas_juridicas/1
      def update
        if @pessoa_juridica.update(pessoa_juridica_params)
          render json: @pessoa_juridica, status: 200
        else
          render json: @pessoa_juridica.errors, status: 422
        end
      end

      # DELETE /pessoas_juridicas/1
      def destroy
        @pessoa_juridica.destroy
        head 204
      end

      private
      # Use callbacks to share common setup or constraints between actions.
      def set_pessoa_juridica
        @pessoa_juridica = PessoaJuridica.find(params[:id])

        rescue
          head 404
      end

      # Only allow a trusted parameter "white list" through.
      def pessoa_juridica_params
        params.require(:pessoa_juridica).permit(:cnpj, :razao_social, :nome_fantasia)
      end
    end
  end
end

