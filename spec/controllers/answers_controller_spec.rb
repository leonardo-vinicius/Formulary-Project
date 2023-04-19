require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe AnswersController, type: :controller do

  let!(:answer_list) { FactoryBot.create_list(:answer, 5) }
  let!(:answer) { FactoryBot.attributes_for(:answer, formulary_id: Formulary.first.id, question_id: Question.first.id, visit_id: Visit.first.id) }
  let(:info_json) { JSON.parse(response.body) }
  let!(:auth_token) { JsonWebToken.encode(user_id: User.first.id) }

  before do
    headers = { 'Authorization' => "Bearer #{auth_token}" }
    allow_any_instance_of(ActionDispatch::Request).to receive(:headers).and_return(headers)
  end

  context 'to get all answers' do
    describe 'GET all answers', type: :request do     
      before { get '/answers' }

      it 'Get answers all sucess' do
        expect(response).to have_http_status(200)
      end

      it 'Get answers keys sucess' do
        expect(info_json.first.keys).to match_array(['id', 'content', 'answered_at', 'formulary_id', 'question_id', 'visit_id', 'created_at', 'updated_at'])
      end

      it 'Get answers parameters sucess' do
        expect(info_json.first['content']).to_not be_nil
      end
    end
  end

  context 'to get answer by index' do
    describe 'GET answer/index', type: :request do
      before { get "/answers/#{answer_list[0].id}" }
      
      it 'Get answers index sucess' do
        expect(response).to have_http_status(200)
      end
      
      it 'Get answer params key sucess' do
        expect(info_json.keys).to match_array(['id', 'content', 'answered_at', 'formulary_id', 'question_id', 'visit_id', 'created_at', 'updated_at'])
      end

      it 'Get answer index sucess' do
        expect(info_json['content']).to_not be_nil
      end

      it 'Is the really id' do
        expect(info_json['id']).to eq(answer_list[0].id)
      end
    end
  end

  context 'to get answer by index inexistent' do
    describe 'GET answers/index', type: :request do
      before { get "/answers/#{99}" }

      it 'Get answers index fail not found' do
        expect(response).to have_http_status(404)
      end
    end
  end

  context 'POST answer create' do
    describe 'POST answers', type: :request do
      before { post '/answers', params: { content: answer[:content], formulary_id: answer[:formulary_id], question_id: answer[:question_id], visit_id: answer[:visit_id]} }

      it 'sucess when create a new answer' do
        expect(response).to have_http_status(200)
      end

      it 'creates a new answer' do
        expect(info_json['content']).to_not be_nil
      end
      
      it 'one more answer' do
        expect(Answer.all.size).to eq(6)
      end
    end
  end

  context 'POST answer create invalid' do
    describe 'Post answers - invalid atributtes', type: :request do
      # question_id -> nil 
      before { post '/answers', params:{ content: answer[:content], formulary_id: answer[:formulary_id], visit_id: answer[:visit_id]} }
    
      it 'failed with create a answer' do
        expect(response).to have_http_status(422)
      end

      it 'answers dont exist' do
        expect(Answer.find_by(content: answer[:content])).to be_nil
      end
    end
  end

  context 'Update a answer by id' do
    describe 'Update answer sucessful', type: :request do
      before { patch answer_path(answer_list[0]), params: { content: 'Meu nome é Leo', formulary_id: answer[:formulary_id], question_id: answer[:question_id], visit_id: answer[:visit_id]} }

      it 'ok status' do
        expect(response).to have_http_status(200)
      end

      it 'update sucessful example by name' do
        expect(info_json['content']).to eq('Meu nome é Leo')
      end
    end
  end

  context 'Delete a answer by id' do
    describe 'Update answer sucessful', type: :request do
      before { delete answer_path(answer_list[4]) }

      it 'ok status delete' do
        expect(response).to have_http_status(200)
      end

      it 'not found deleted answer' do
        expect(Answer.find_by(id: answer_list[4].id)).to be_nil
      end

      it 'one less answer' do
        expect(Answer.all.size).to eq(4)
      end
    end
  end

end