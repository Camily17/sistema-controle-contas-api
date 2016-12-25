require 'rails_helper'

RSpec.describe API::V1::TransacoesController, type: :controller do
  before { @request.host = 'api.example.com' }
  before do
    headers = { 'Accept' => Mime[:json], 'Content-Type' => Mime[:json].to_s }
    request.headers.merge! headers
  end

  context 'Transação do tipo carga' do
    before(:all) { DatabaseCleaner.clean_with(:deletion) }

    let!(:transacao_carga) { FactoryGirl.create(:transacao_carga, :campos_completos) }
    let(:atributos_validos) { FactoryGirl.attributes_for(:transacao_carga) }
    let(:atributos_invalidos) { FactoryGirl.attributes_for(:transacao_carga, :campos_invalidos) }

    describe 'GET #index' do
      it_behaves_like 'GET #index', Transacao do
        let(:parametros) { {} }
        let(:objeto_esperado) { transacao_carga }
        let(:numero_registros) { 1 }
      end
    end

    describe 'GET #show' do
      it_behaves_like 'GET #show', Transacao do
        let(:parametros) { { id: transacao_carga.id } }
        let(:objeto_esperado) { transacao_carga }

        let(:parametro_id_invalido) { { id: atributos_invalidos[:id] } }
      end
    end

    describe 'POST #create' do
      it_behaves_like 'POST #create', Transacao do
        let(:parametros_validos) { { transacao: atributos_validos } }

        let(:parametros_invalidos) { { transacao: atributos_invalidos } }
      end

      it 'atualizar saldo da conta origem' do
        conta_origem = Conta.find_by(id: atributos_validos[:conta_origem_id])

        expect {
          post :create, body: atributos_validos.to_json
        }.to change(Transacao, :count).by(1)

        expect(conta_origem.reload.saldo).to eq(500)
      end
    end
  end

  context 'Transação do tipo transferência' do
    before(:all) { DatabaseCleaner.clean_with(:deletion) }

    let!(:transacao_transferencia_hierarquia) { FactoryGirl.create(:transacao_transferencia_hierarquia, :campos_completos) }

    describe 'GET #index' do
      it_behaves_like 'GET #index', Transacao do
        let(:parametros) { {} }
        let(:objeto_esperado) { transacao_transferencia_hierarquia }
        let(:numero_registros) { 1 }
      end
    end

    describe 'GET #show' do
      it_behaves_like 'GET #show válido', Transacao do
        let(:parametros) { { id: transacao_transferencia_hierarquia.id } }
        let(:objeto_esperado) { transacao_transferencia_hierarquia }
      end
    end

    describe 'POST #create' do
      context 'com campos válidos' do
        context 'e hierarquia' do
          context 'válida' do
            let(:atributos_validos_estorno_carga) { Objetos.converter_hash_simbolizado(FactoryGirl.build(:transacao_transferencia_hierarquia, :igual)) }

            it_behaves_like 'POST #create válido', Transacao do
              let(:parametros_validos) { { transacao: atributos_validos_estorno_carga } }
            end

            it 'deve atualizar campos' do
              atributos_validos_estorno_carga =  Objetos.converter_hash_simbolizado(FactoryGirl.build(:transacao_transferencia_hierarquia, :igual))
              conta_origem = Conta.find_by(id: atributos_validos_estorno_carga[:conta_origem_id])
              conta_destino = Conta.find_by(id: atributos_validos_estorno_carga[:conta_destino_id])

              expect {
                post :create, body: atributos_validos_estorno_carga.to_json
              }.to change(Transacao, :count).by(1)

              expect(conta_origem.reload.saldo).to eq(750)
              expect(conta_destino.reload.saldo).to eq(250)
            end
          end

          context 'inválida' do
            let(:atributos_validos_estorno_carga_diferente) { Objetos.converter_hash_simbolizado(FactoryGirl.build(:transacao_transferencia_hierarquia, :diferente)) }

            it_behaves_like 'POST #create inválido', Transacao do
              let(:parametros_invalidos) { { transacao: atributos_validos_estorno_carga_diferente } }
            end

            it 'não deve atualizar campos' do
              atributos_validos_estorno_carga_diferente = Objetos.converter_hash_simbolizado(FactoryGirl.build(:transacao_transferencia_hierarquia, :diferente))
              conta_origem = Conta.find_by(id: atributos_validos_estorno_carga_diferente[:conta_origem_id])
              conta_destino = Conta.find_by(id: atributos_validos_estorno_carga_diferente[:conta_destino_id])

              expect {
                post :create, body: atributos_validos_estorno_carga_diferente.to_json
              }.not_to change(Transacao, :count)

              expect(conta_origem.reload.saldo).to eq(1000)
              expect(conta_destino.reload.saldo).to eq(0)
            end
          end
        end

        context 'e conta destino matriz deve ser inválido' do
          context 'deve ser inválida' do
            it 'não atualizar saldo da conta origem e destino' do
              atributos_validos_matriz_invalida =  Objetos.converter_hash_simbolizado(FactoryGirl.build(:transacao_transferencia_matriz, :valida))
              conta_origem = Conta.find_by(id: atributos_validos_matriz_invalida[:conta_origem_id])
              conta_destino = Conta.find_by(id: atributos_validos_matriz_invalida[:conta_destino_id])

              expect {
                post :create, body: atributos_validos_matriz_invalida.to_json
              }.not_to change(Transacao, :count)

              expect(conta_origem.reload.saldo).to eq(1000)
              expect(conta_destino.reload.saldo).to eq(0)
            end
          end
        end
      end
    end
  end

  context 'Transação do tipo estorno' do
    context 'de carga' do
      before(:all) { DatabaseCleaner.clean_with(:deletion) }

      let!(:transacao_estorno_carga) { FactoryGirl.create(:transacao_estorno_carga, :campos_completos) }

      describe 'GET #index' do
        it_behaves_like 'GET #index', Transacao do
          let(:parametros) { {} }
          let(:objeto_esperado) { transacao_estorno_carga }
          let(:numero_registros) { 2 }
        end
      end

      describe 'GET #show' do
        it_behaves_like 'GET #show válido', Transacao do
          let(:parametros) { { id: transacao_estorno_carga.id } }
          let(:objeto_esperado) { transacao_estorno_carga }
        end
      end

      describe 'POST #create' do
        context 'de carga' do
          context ' com atributos válidos' do
            let!(:atributos_validos_estorno_carga) { Objetos.converter_hash_simbolizado(FactoryGirl.build(:transacao_estorno_carga, :valida)) }

            it_behaves_like 'POST #create válido', Transacao do
              let(:parametros_validos) { { transacao: atributos_validos_estorno_carga } }
            end

            it 'deve estornar transação e não deixar estorná-la novamente' do
              atributos_validos_estorno_carga = Objetos.converter_hash_simbolizado(FactoryGirl.build(:transacao_estorno_carga, :valida))
              transacao_carga_estornar = Transacao.find_by(codigo_transacional: atributos_validos_estorno_carga[:codigo_transacional_estornado])
              conta_origem = Conta.find_by(id: transacao_carga_estornar[:conta_origem_id])

              # Estorna transação carga
              expect {
                post :create, body: atributos_validos_estorno_carga.to_json
              }.to change(Transacao, :count).by(1)

              expect(conta_origem.reload.saldo).to eq(0)

              # Não estorna transação carga
              expect {
                post :create, body: atributos_validos_estorno_carga.to_json
              }.not_to change(Transacao, :count)

              expect(conta_origem.reload.saldo).to eq(0)
            end
          end
        end
      end
    end

    context 'de transferência' do
      before(:all) { DatabaseCleaner.clean_with(:deletion) }

      let!(:transacao_estorno_transferencia) { FactoryGirl.create(:transacao_estorno_transferencia, :campos_completos) }

      describe 'GET #index' do
        it_behaves_like 'GET #index', Transacao do
          let(:parametros) { {} }
          let(:objeto_esperado) { transacao_estorno_transferencia }
          let(:numero_registros) { 2 }
        end
      end

      describe 'GET #show' do
        it_behaves_like 'GET #show válido', Transacao do
          let(:parametros) { { id: transacao_estorno_transferencia.id } }
          let(:objeto_esperado) { transacao_estorno_transferencia }
        end
      end

      describe 'POST #create' do
        context ' com atributos válidos' do
          let!(:atributos_validos_estorno_transferencia) { Objetos.converter_hash_simbolizado(FactoryGirl.build(:transacao_estorno_transferencia, :valida)) }

          it_behaves_like 'POST #create válido', Transacao do
            let(:parametros_validos) { { transacao: atributos_validos_estorno_transferencia } }
          end

          it 'deve estornar transação e não deixar estorná-la novamente' do
            atributos_validos_estorno_transferencia = Objetos.converter_hash_simbolizado(FactoryGirl.build(:transacao_estorno_transferencia, :valida))
            transacao_carga_estornar = Transacao.find_by(codigo_transacional: atributos_validos_estorno_transferencia[:codigo_transacional_estornado])
            conta_origem = Conta.find_by(id: transacao_carga_estornar[:conta_origem_id])
            conta_destino = Conta.find_by(id: transacao_carga_estornar[:conta_destino_id])

            # Estorna transação carga
            expect {
              post :create, body: atributos_validos_estorno_transferencia.to_json
            }.to change(Transacao, :count).by(1)

            expect(conta_origem.reload.saldo).to eq(1000)
            expect(conta_destino.reload.saldo).to eq(0)

            # Não estorna transação carga
            expect {
              post :create, body: atributos_validos_estorno_transferencia.to_json
            }.not_to change(Transacao, :count)

            expect(conta_origem.reload.saldo).to eq(1000)
            expect(conta_destino.reload.saldo).to eq(0)
          end
        end
      end
    end
  end
end
