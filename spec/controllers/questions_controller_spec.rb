require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe QuestionsController, type: :controller do

    let(:user) { FactoryBot.create(:user) }
    let(:visit){ FactoryBot.create(:visit, user_id:user.id)}
    let!(:formulary) {FactoryBot.create(:formulary, visit_id: visit.id)}

    let!(:question3){FactoryBot.attributes_for(:question3, formulary_id: formulary.id)}
    let!(:question){FactoryBot.create(:question, formulary_id: formulary.id)}
    let!(:question2){FactoryBot.create(:question2, formulary_id: formulary.id)}

    let!(:auth_token) { JsonWebToken.encode(user_id: user.id) }

    context "GET to get all questions"do
        describe"GET all questions", type: :request do     
            before { get "/questions", headers: { 'Authorization' => 'Bearer ' + auth_token } }

            it "Get questions all sucess"do
                expect(response).to have_http_status(200)
            end

            it "Get questions keys sucess"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json.first.keys).to match_array(["id", "name", "tipo_pergunta", "formulary_id", "created_at", "updated_at"])
            end

            it "Get questions parameters sucess"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json.first["name"]).to eq("Pergunta 1")
            end
        end
    end

    context "GET to get question by index"do
        describe "GET question/index", type: :request do
        
            before {get "/questions/#{question2.id}", headers: { 'Authorization' => 'Bearer ' + auth_token }}
            
            it "Get questions index sucess"do
            expect(response).to have_http_status(200)
            end
            
            it "Get question params key sucess"do
            parsed_response = JSON.parse(response.body)
            info_json = parsed_response
            expect(info_json.keys).to match_array(["id", "name", "tipo_pergunta", "formulary_id", "created_at", "updated_at"])
            end

            it "Get question index sucess"do
            parsed_response = JSON.parse(response.body)
            info_json = parsed_response
            expect(info_json["name"]).to eq("Pergunta 2")
            end

            it "Is the really id"do
            parsed_response = JSON.parse(response.body)
            info_json = parsed_response
            expect(info_json["id"]).to eq(question2.id)
            end
        end
    end

    context "GET to get question by index inexistent"do
        describe "GET questions/index", type: :request do
        
        before {get "/questions/#{99}", headers: { 'Authorization' => 'Bearer ' + auth_token }}
            it "Get questions index fail not found"do
                expect(response).to have_http_status(404)
            end
        end
    end

    context "POST question create" do
        describe "POST questions", type: :request do
          before { post "/questions", params:{ name: question3[:name], tipo_pergunta:question3[:tipo_pergunta], formulary_id:question3[:formulary_id]}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
    
          it "sucess when create a new question"do
            expect(response).to have_http_status(200)
          end
    
          it "creates a new question" do
            expect(Question.find_by(name:question[:name])).to_not be_nil
          end
        end 
    end

    context "POST repeat question create not permited" do
        describe "POST questions repeat not permited", type: :request do
          # tentando colocar pergunta repetida entre formularios (question2 no mesmo formulario criado na linha 9)
          before { post "/questions", params:{ name: question2[:name], tipo_pergunta:question2[:tipo_pergunta], formulary_id:question2[:formulary_id]}, headers: { 'Authorization' => 'Bearer ' + auth_token } }
    
          it "fail when create a repeat question"do
            expect(response).to have_http_status(422)
          end

        end 
    end

    context "POST question create fail" do
        describe "POST questions fail", type: :request do
          # faltando um parametro
          before { post "/questions", params:{ name: question[:name], formulary_id:question[:formulary_id]}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
    
          it "fail when create a repeat question"do
            expect(response).to have_http_status(422)
          end

        end 
    end

    context "PATCH/PUT Update a question by id"do
        describe "Update question sucessful", type: :request do
            before { patch question_path(question), params: { name: "Qual o seu nome?", tipo_pergunta:"texto", formulary_id:1}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
            it "ok status"do
                expect(response).to have_http_status(200)
            end
            it "update sucessful example by name"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json["name"]).to eq("Qual o seu nome?")
            end
        end
    end

    context "DELETE Delete a question by id"do
        describe "Update question sucessful", type: :request do
            before { delete question_path(question2), headers: { 'Authorization' => 'Bearer ' + auth_token }}
            it "ok status delete"do
                expect(response).to have_http_status(200)
            end

            it "not found deleted question"do
                expect(Question.find_by(id:question2.id)).to be_nil
            end
        end
    end

end