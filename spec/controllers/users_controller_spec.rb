require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe UsersController, type: :controller do

  let!(:user1) { FactoryBot.attributes_for(:user) }
  let!(:user2) { FactoryBot.create(:user2) }
  let!(:user3) { FactoryBot.create(:user3) }
  
  let!(:auth_token) { JsonWebToken.encode(user_id: user2.id) }
  #GET /users  users#index
  context "to get all users"do
    describe"GET all users", type: :request do     
        #before { get "/users" }
        before {get '/users', headers: { 'Authorization' => 'Bearer ' + auth_token }}

        it "Get users all sucess"do
          expect(response).to have_http_status(200)
        end

        it "Get users keys sucess"do
          parsed_response = JSON.parse(response.body)
          info_json = parsed_response
          expect(info_json.first.keys).to match_array(["id", "name", "email", "password_digest", "cpf", "created_at", "updated_at"])
        end

        it "Get users parameters sucess"do
          parsed_response = JSON.parse(response.body)
          info_json = parsed_response
          expect(info_json.first["name"]).to eq("Leonardo")
        end
    end
  end
 #GET /users/:id(.:format)  users#show
  context "to get user by index"do
    describe "GET user/index", type: :request do
      
        before {get "/users/#{user2.id}", headers: { 'Authorization' => 'Bearer ' + auth_token }}
        
        it "Get users index sucess"do
          expect(response).to have_http_status(200)
        end
        
        it "Get user params key sucess"do
          parsed_response = JSON.parse(response.body)
          info_json = parsed_response
          expect(info_json.keys).to match_array(["id", "name", "email", "password_digest", "cpf", "created_at", "updated_at"])
        end

        it "Get user index sucess"do
          parsed_response = JSON.parse(response.body)
          info_json = parsed_response
          expect(info_json["name"]).to eq("Leonardo")
        end

        it "Is the really id"do
          parsed_response = JSON.parse(response.body)
          info_json = parsed_response
          expect(info_json["id"]).to eq(user2.id)
        end
    end
  end
  #GET /users/:id(.:format)  users#show
  context "to get user by index inexistent"do
    describe "GET users/index", type: :request do
      
      before {get "/users/#{55}", headers: { 'Authorization' => 'Bearer ' + auth_token }}
      it "Get users index fail not found"do
        expect(response).to have_http_status(404)
      end
    end
  end
  # POST /users
  context "User create" do
    describe "POST users", type: :request do
      before { post "/users", params:{ name: user1[:name], email:user1[:email], password:user1[:password], cpf:user1[:cpf]}}

      it "sucess when create a new user"do
        expect(response).to have_http_status(200)
      end

      it "creates a new user" do
        expect(User.find_by(name:user1[:name])).to_not be_nil
      end
    end 
  end
  # POST /users 
  context "User create invalid" do
    describe "Post users - invalid atributtes", type: :request do
        # criando um user com senha sem numero algo que não é permitido
        before {post "/users", params:{name:"Leo" , email:"leo@gmail.com", password:"senha_sem_numero", cpf:"22004867078"}}
      
        it"failed with create a user"do
            #byebug
            expect(response).to have_http_status(422)
        end

        it "users dont exist"do
          expect(User.find_by(name: "Leo")).to be_nil
        end
    end
  end
  # PATCH/PUT users/:id
  context "Update a user by id"do
    describe "Update user sucessful", type: :request do
        before { patch user_path(user3), params: { name: "Nalanda Vitória", email:"nalanda@hotmail.com", password:"nalanda123", cpf:"91013283015"}, headers: { 'Authorization' => 'Bearer ' + auth_token } }
        it "ok status"do
          expect(response).to have_http_status(200)
        end
        it "update sucessful example by name"do
          parsed_response = JSON.parse(response.body)
          info_json = parsed_response
          expect(info_json["name"]).to eq("Nalanda Vitória")
      end
    end
  end
# DELETE users/:id
  context "Delete a user by id"do
      describe "Update user sucessful", type: :request do
          before { delete user_path(user2), headers: { 'Authorization' => 'Bearer ' + auth_token }}
          it "ok status delete"do
            expect(response).to have_http_status(200)
          end

          it "not found deleted user"do
            expect{get "/users/#{user2.id}", headers: { 'Authorization' => 'Bearer ' + auth_token }}.to raise_error(ActiveRecord::RecordNotFound)
          end
      end
  end

end
#{"id"=>2, "name"=>"Leo", "email"=>"leo@gmail.com", "password_digest"=>"$2a$04$rBnl94rMNy.z7pqzzi6bOeoJ6BQDFGrFCn1QSdlZNH1r2ioh.Wk8u", "cpf"=>"22004867078", "created_at"=>"2023-03-31T13:18:13.229Z", "updated_at"=>"2023-03-31T13:18:13.229Z"}