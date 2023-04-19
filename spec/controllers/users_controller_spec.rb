require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe UsersController, type: :controller do

  let!(:user_list){ FactoryBot.create_list(:user, 5) }
  let!(:user1) { FactoryBot.attributes_for(:user) }
  let(:info_json) { JSON.parse(response.body) }
  let!(:auth_token) { JsonWebToken.encode(user_id: user_list[0].id) }

  before do
    headers = { 'Authorization' => "Bearer #{auth_token}" }
    allow_any_instance_of(ActionDispatch::Request).to receive(:headers).and_return(headers)
  end

  # GET /users  users#index
  context 'to get all users' do
    describe'GET all users', type: :request do     
      before { get '/users' }

      it 'Get users all sucess' do
        expect(response).to have_http_status(200)
      end

      it 'Get users keys sucess' do
        expect(info_json.first.keys).to match_array(['id', 'name', 'email', 'password_digest', 'cpf', 'created_at', 'updated_at'])
      end

      it 'Get users parameters sucess' do
        expect(User.all.size).to eq(5)
      end
    end
  end
  # GET /users/:id(.:format)  users#show
  context 'to get user by index' do
    describe 'GET user/index', type: :request do
      before { get "/users/#{user_list[0].id}" }
      
      it 'Get users index sucess' do
        expect(response).to have_http_status(200)
      end
      
      it 'Get user params key sucess' do
        expect(info_json.keys).to match_array(['id', 'name', 'email', 'password_digest', 'cpf', 'created_at', 'updated_at'])
      end
      
      it 'Parameters is not to be nil' do
        expect(info_json['name']).to_not be_nil
      end

      it 'Is the really id' do
        expect(info_json['id']).to eq(user_list[0].id)
      end
    end
  end
  # GET /users/:id(.:format)  users#show
  context 'to get user by index inexistent' do
    describe 'GET users/index', type: :request do
      
      before { get "/users/#{99}", headers: headers }
      it 'Get users index fail not found' do
        expect(response).to have_http_status(404)
      end
    end
  end
  # POST /users
  context 'User create' do
    describe 'POST users', type: :request do
      before { post '/users', params:{ name: user1[:name], email: user1[:email], password: user1[:password], cpf: user1[:cpf]}}

      it 'sucess when create a new user' do
        expect(response).to have_http_status(200)
      end

      it 'creates a new user' do
        expect(User.find_by(name:user1[:name])).to_not be_nil
      end
    end 
  end
  # POST /users 
  context 'User create invalid' do
    describe 'Post users - invalid atributtes', type: :request do
      before { post '/users', params:{name:'Leonardo Vinicius Wanderley' , email:'leo@gmail.com', password:'senha_sem_numero', cpf:'22004867078'} }
    
      it'failed with create a user' do
        expect(response).to have_http_status(422)
      end

      it 'users dont exist' do
        expect(User.find_by(name: 'Leonardo Vinicius Wanderley')).to be_nil
      end
    end
  end
  # PATCH/PUT users/:id
  context 'Update a user by id' do
    describe 'Update user sucessful', type: :request do
      before { patch user_path(user_list[1]), params: { name:'Nalanda Vitória Miranda', email:'nalanda@gmail.com', password:'#Password123', cpf: user_list[1].cpf} }
      
      it 'ok status'do
        expect(response).to have_http_status(200)
      end

      it 'update sucessful example by name' do
        expect(info_json['name']).to eq('Nalanda Vitória Miranda')
      end
    end
  end
  # DELETE users/:id
  context 'Delete a user by id' do
    describe 'Update user sucessful', type: :request do
      before { delete user_path(user_list[4]) }

      it 'ok status delete' do
        expect(response).to have_http_status(200)
      end

      it 'not found deleted user' do
        expect(User.find_by(id: user_list[4].id)).to be_nil
      end

      it 'one less user' do
        expect(User.all.size).to eq(4)
      end
    end
  end
end