require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe QuestionsController, type: :controller do

  let!(:question){ FactoryBot.attributes_for(:question) }
  let!(:question_list){ FactoryBot.create_list(:question, 5) }
  let(:info_json) { JSON.parse(response.body) }
  let!(:auth_token) { JsonWebToken.encode(user_id: User.first.id) }
    
  before do
    headers = { 'Authorization' => "Bearer #{auth_token}" }
    allow_any_instance_of(ActionDispatch::Request).to receive(:headers).and_return(headers)
  end

  context 'GET to get all questions' do
    describe 'GET all questions', type: :request do     
      before { get '/questions' }
  
      it 'Get questions all sucess' do
        expect(response).to have_http_status(200)
      end
  
      it 'Get questions keys sucess' do
        expect(info_json.first.keys).to match_array(['id', 'name', 'tipo_pergunta', 'formulary_id', 'created_at', 'updated_at'])
      end
  
      it 'Get questions parameters sucess' do
        expect(info_json.first['name']).to_not be_nil
      end
    end
  end
  
  context 'GET to get question by index' do
    describe 'GET question/index', type: :request do
      before { get "/questions/#{question_list[0].id}" }
        
      it 'Get questions index sucess' do
        expect(response).to have_http_status(200)
      end
        
      it 'Get question params key sucess' do
        expect(info_json.keys).to match_array(['id', 'name', 'tipo_pergunta', 'formulary_id', 'created_at', 'updated_at'])
      end
  
      it 'Get question index sucess' do
        expect(info_json['name']).to_not be_nil
      end
  
      it 'Is the really id' do
        expect(info_json['id']).to eq(question_list[0].id)
      end
    end
  end
  
  context 'GET to get question by index inexistent' do
    describe 'GET questions/index', type: :request do
      before { get "/questions/#{99}", headers: headers }
  
      it 'Get questions index fail not found' do
        expect(response).to have_http_status(404)
      end
    end
  end
  

  context 'POST question create sucess' do
    describe 'POST questions', type: :request do
      before { post '/questions', params:{ name: question[:name], tipo_pergunta:question[:tipo_pergunta], formulary_id:Question.first.id} }
  
      it 'sucess when create a new question' do
        expect(response).to have_http_status(200)
      end
  
      it 'creates a new question' do
        expect(Question.find_by(name:question[:name])).to_not be_nil
      end
  
      it 'one less question' do
        expect(Question.all.size).to eq(6)
      end
    end 
  end
  
  context 'POST repeat question create not permited' do
    describe 'POST questions repeat not permited', type: :request do
      before { post '/questions', params:{ name: question[:name], tipo_pergunta:question[:tipo_pergunta], formulary_id:question[:formulary_id]} }
  
      it 'fail when create a repeat question' do
        expect(response).to have_http_status(422)
      end
    end 
  end
  
  context 'POST question create fail' do
    describe 'POST questions fail', type: :request do
      # tipo_pergunta -> nil 
      before { post '/questions', params:{ name: 'What is your smartphone?', formulary_id: question[:formulary_id]} }
  
      it 'fail when create a repeat question' do
        expect(response).to have_http_status(422)
      end
    end 
  end
  
  context 'PATCH/PUT Update a question by id' do
    describe 'Update question sucessful', type: :request do
      before { patch question_path(question_list[0]), params: { name: 'Qual o seu nome?', tipo_pergunta: 'texto', formulary_id: 1 } }
  
      it 'ok status' do
        expect(response).to have_http_status(200)
      end
  
      it 'update sucessful example by name' do
        expect(info_json['name']).to eq('Qual o seu nome?')
      end
    end
  end
  
  context 'DELETE Delete a question by id' do
    describe 'Update question sucessful', type: :request do
      before { delete question_path(question_list[1]) }
  
      it 'ok status delete' do
        expect(response).to have_http_status(200)
      end
  
      it 'not found deleted question' do
        expect(Question.find_by(id: question_list[1].id)).to be_nil
      end
  
      it 'one less question' do
        expect(Question.all.size).to eq(4)
      end
    end
  end
  
end