require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe FormulariesController, type: :controller do
    
  let!(:formulary_list) { FactoryBot.create_list(:formulary, 5) }
  let(:formulary) { FactoryBot.attributes_for(:formulary)}
  let(:info_json) { JSON.parse(response.body) }
  let!(:auth_token) { JsonWebToken.encode(user_id: User.last.id) }

  before do
    headers = { 'Authorization' => "Bearer #{auth_token}" }
    allow_any_instance_of(ActionDispatch::Request).to receive(:headers).and_return(headers)
  end

  context 'GET all formularies' do
    describe 'GET all formularies', type: :request do     
      before { get '/formularies' }
  
      it 'Get formularies all sucess' do
        expect(response).to have_http_status(200)
      end
  
      it 'Get formulary keys sucess' do
        expect(info_json.first.keys).to match_array(['id', 'name', 'visit_id', 'created_at', 'updated_at'])
      end
  
      it 'Get formularies parameters sucess' do
        expect(info_json.first['name']).to_not be_nil
      end
  
      it 'create all formularies' do
        expect(Formulary.all.size).to eq(5)
      end
    end
  end
  

  context 'to get formulary by index' do
    describe 'GET formulary/index', type: :request do
          
      before { get "/formularies/#{formulary_list[0].id}" }
              
      it 'Get formularies index sucess' do
        expect(response).to have_http_status(200)
      end
              
      it 'Get formulary params key sucess' do
        expect(info_json.keys).to match_array(['id', 'name', 'visit_id', 'created_at', 'updated_at'])
      end
  
      it 'Get formulary index sucess' do
        expect(info_json['name']).to_not be_nil
      end
  
      it 'Is the really id' do
        expect(info_json['id']).to eq(formulary_list[0].id)
      end
    end
  end
  
  context 'formulary POST' do
    before { post '/formularies', params:{name: formulary[:name], visit_id: Formulary.first.id} }
    
    describe 'sucess formulary create', type: :request do
      it 'formulary sucess response' do
        expect(response).to have_http_status(200)
      end 
  
      it 'formulary name exist' do
        expect(Formulary.find_by(name:formulary[:name])).to_not be_nil 
      end
  
      it 'one more formulary' do
        expect(Formulary.all.size).to eq(6)
      end
    end
  end
  

  context 'formulary POST fail' do
    before { 
      post '/formularies', params: { 
        name: nil, 
        visit_id: formulary[:visit_id] 
      } 
    }
  
    describe 'fail formulary create', type: :request do
      it 'formulary fail response - unprocessable' do
        expect(response).to have_http_status(422)
      end 
    end
  end
  
  context 'Update a formulary by id' do
    describe 'Update formulary successful', type: :request do
      before { 
        patch formulary_path(formulary_list[0]), params: { 
          name: 'Formulario nome alterado', 
          visit_id: formulary_list[0][:visit_id] 
        } 
      }
  
      it 'ok status' do
        expect(response).to have_http_status(200)
      end
  
      it 'update successful example by name' do
        expect(info_json['name']).to eq('Formulario nome alterado')
      end
    end
  end
  
  context 'Delete a formulary by id' do
    describe 'Update formulary successful', type: :request do
      before { delete formulary_path(formulary_list[2]) }
  
      it 'ok status delete' do
        expect(response).to have_http_status(200)
      end
  
      it 'not found deleted formulary' do
        expect(Formulary.find_by(id: formulary_list[2].id)).to be_nil
      end
  
      it 'one less formulary' do
        expect(Formulary.all.size).to eq(4)
      end
    end
  end
  
end