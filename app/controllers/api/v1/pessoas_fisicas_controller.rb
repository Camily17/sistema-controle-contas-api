module API
  module V1
    class PessoasFisicasController < ApplicationController
      before_action :set_pessoa_fisica, only: [:show, :update, :destroy]

      # GET /pessoas_fisicas
      def index
        @pessoas_fisicas = PessoaFisica.all

        render json: @pessoas_fisicas, status: 200
      end

      # GET /pessoas_fisicas/1
      def show
        render json: @pessoa_fisica, status: 200
      end

      # POST /pessoas_fisicas
      def create
        @pessoa_fisica = PessoaFisica.new(pessoa_fisica_params)

        if @pessoa_fisica.save
          head 204, location: api_v1_pessoa_fisica_url(@pessoa_fisica.id)
        else
          render json: @pessoa_fisica.errors, status: 422
        end
      end

      # PATCH/PUT /pessoas_fisicas/1
      def update
        if @pessoa_fisica.update(pessoa_fisica_params)
          render json: @pessoa_fisica
        else
          render json: @pessoa_fisica.errors, status: 422
        end
      end

      # DELETE /pessoas_fisicas/1
      def destroy
        @pessoa_fisica.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_pessoa_fisica
          @pessoa_fisica = PessoaFisica.find(params[:id])

          rescue
            head 404
        end

        # Only allow a trusted parameter "white list" through.
        def pessoa_fisica_params
          params.require(:pessoa_fisica).permit(:cpf, :nome, :data_nascimento)
        end
    end

  end
end

