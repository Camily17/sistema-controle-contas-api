RSpec.shared_examples 'PATCH #update' do |klass|
  context 'com parâmetros válidos' do
    before { patch :update, params: { id: parametro_id_valido }, body: parametros_validos.to_json  }

    it 'atualiar a pessoa_fisica requisitada' do
      objeto_esperado.reload
      expect(objeto_esperado_atributo).to eq(atributo_atualizado_valido)
    end

    context 'retornar mime type esperado' do
      it_behaves_like 'mime type JSON'
    end

    context 'retornar status code esperado' do
      it_behaves_like '200 - :ok'
    end
  end

  context 'com parâmetros inválidos' do
    context 'com o id válido' do
      before { patch :update, params: { id: parametro_id_valido }, body: parametros_invalidos.to_json }

      it "não atualizar o objeto #{klass.to_s.underscore} requisitado" do
        objeto_esperado.reload
        expect(objeto_esperado_atributo).not_to eq(atributo_atualizado_invalido)
      end

      context 'retornar mime type esperado' do
        it_behaves_like 'mime type JSON'
      end

      context 'retornar status code esperado' do
        it_behaves_like '422 - :unprocessable_entity'
      end
    end

    context 'com o id inválido' do
      before { patch :update, params: { id: parametro_id_invalido }, body: parametros_invalidos.to_json }

      context 'retornar status code esperado' do
        it_behaves_like '404 - :not_found'
      end
    end
  end
end