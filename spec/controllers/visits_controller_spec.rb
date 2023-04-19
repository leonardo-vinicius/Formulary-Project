require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe VisitsController, type: :controller do
    
  let!(:visit){ FactoryBot.attributes_for(:visit) }
  let!(:visit_list){ FactoryBot.create_list(:visit, 5) }
  let(:info_json) { JSON.parse(response.body) }
  let!(:auth_token) { JsonWebToken.encode(user_id: User.first.id) }

  before do
    headers = { 'Authorization' => "Bearer #{auth_token}" }
    allow_any_instance_of(ActionDispatch::Request).to receive(:headers).and_return(headers)
  end

  context 'GET visit all sucess' do
    describe 'GET visits sucess by index', type: :request do
      before { get '/visits' }
      
      it 'request sucess' do
        expect(response).to have_http_status(200)
      end
  
      it 'all visits are created' do
        expect(Visit.all.size).to eq(5)
      end
    end
  end
  

  context 'GET visit by index sucess' do
    describe 'GET visits sucess by index', type: :request do
      before { get "/visits/#{visit_list[0].id}" }
      
      it 'request sucess' do
        expect(response).to have_http_status(200)
      end
  
      it 'Get visits params key sucess' do
        expect(info_json.keys).to match_array(['id', 'data', 'status', 'checkin_at', 'checkout_at', 'created_at', 'updated_at', 'user_id'])
      end
  
      it 'Get user index sucess' do
        expect(info_json['data']).to_not be_nil 
      end
  
      it 'Is the really id' do
        expect(info_json['id']).to eq(visit_list[0].id)
      end
    end
  end
  

  context 'GET visit by index inexistent - fail' do
    describe 'GET visits fail by index', type: :request do
      before { get "/visits/#{99}" }
  
      it 'Not found error index inexistent' do
        expect(response).to have_http_status(404)
      end
    end
  end
  
  context 'POST visit sucess' do
    describe 'create visit sucess', type: :request do                        
      before { post '/visits', params:{ data:visit[:data], status: visit[:status], checkin_at: visit[:checkin_at], checkout_at: visit[:checkout_at], user_id: User.first.id} }
  
      it 'sucess when create a new visit' do
        expect(response).to have_http_status(200)
      end
  
      it 'sucess and was created a new id' do
        visit = Visit.last
        expect(Visit.find_by(id:visit[:id])).to_not be_nil
      end
  
      it 'it is a new visit' do
        expect(Visit.all.size).to eq(6)
      end
    end
  end
  

  context 'POST visit fail' do
    describe 'create visit fail', type: :request do                        
      before { post '/visits', params:{data:visit[:data], checkin_at: visit[:checkin_at], checkout_at: visit[:checkout_at], user_id: User.first.id} }
          
      it 'fail when create a new visit' do
        expect(response).to have_http_status(422)
      end
    end
  end
  
  context 'Update a visit by id' do
    describe 'Update visit sucessful', type: :request do
      before { patch visit_path(visit_list[0]), params: {data: visit_list[0][:data], status: 'REALIZADO', checkin_at: visit_list[0][:checkin_at], checkout_at: visit_list[0][:checkout_at], user_id: User.first.id} }
  
      it 'ok status' do
        expect(response).to have_http_status(200)
      end
  
      it 'update sucessful example by status' do
        expect(info_json['status']).to eq('REALIZADO')
      end
    end
  end
  
  context 'Delete a visit by id' do
    describe 'Update visit sucessful', type: :request do
      before { delete visit_path(visit_list[3]) }
  
      it 'ok status delete' do
        expect(response).to have_http_status(200)
      end
          
      it 'not found deleted visit' do
        expect(Visit.find_by(id:visit_list[3].id)).to be_nil
      end
  
      it 'one less visit' do
        expect(Visit.all.size).to eq(4)
      end
    end
  end
  
end