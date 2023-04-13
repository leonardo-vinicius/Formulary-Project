require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe AnswersController, type: :controller do

    let(:user) { FactoryBot.create(:user) }
    let(:visit){ FactoryBot.create(:visit, user_id:user.id)}
    let!(:formulary) {FactoryBot.create(:formulary, visit_id: visit.id)}
    let!(:question) {FactoryBot.create(:question, formulary_id: formulary.id)}

    let(:user2) { FactoryBot.create(:user2) }
    let(:visit2){ FactoryBot.create(:visit2, user_id:user2.id)}
    let!(:formulary2) {FactoryBot.create(:formulary2, visit_id: visit2.id)}
    let!(:question2) {FactoryBot.create(:question2, formulary_id: formulary2.id)}

    let(:user3) { FactoryBot.create(:user3) }
    let(:visit3){ FactoryBot.create(:visit3, user_id:user3.id)}
    let!(:formulary3) {FactoryBot.create(:formulary3, visit_id: visit3.id)}
    let!(:question3) {FactoryBot.create(:question3, formulary_id: formulary3.id)}

    let!(:answer) {FactoryBot.create(:answer, formulary_id: formulary.id, question_id: question.id, visit_id: visit.id)}
    let!(:answer2) {FactoryBot.create(:answer2, formulary_id: formulary2.id, question_id: question2.id, visit_id: visit2.id)}
    let!(:answer3) {FactoryBot.attributes_for(:answer3, formulary_id: formulary3.id, question_id: question3.id, visit_id: visit3.id)}

    let!(:auth_token) { JsonWebToken.encode(user_id: user.id) }

    context "to get all answers"do
      describe"GET all answers", type: :request do     
          before { get "/answers", headers: { 'Authorization' => 'Bearer ' + auth_token }}

          it "Get answers all sucess"do
            expect(response).to have_http_status(200)
          end

          it "Get answers keys sucess"do
            parsed_response = JSON.parse(response.body)
            info_json = parsed_response
            expect(info_json.first.keys).to match_array(["id", "content", "answered_at", "formulary_id", "question_id", "visit_id", "created_at", "updated_at"])
          end

          it "Get answers parameters sucess"do
            parsed_response = JSON.parse(response.body)
            info_json = parsed_response
            expect(info_json.first["content"]).to eq("Resposta da pergunta 1")
          end
      end
    end

    context "to get answer by index"do
      describe "GET answer/index", type: :request do
        
          before {get "/answers/#{answer2.id}", headers: { 'Authorization' => 'Bearer ' + auth_token }}
          
          it "Get answers index sucess"do
            expect(response).to have_http_status(200)
          end
          
          it "Get answer params key sucess"do
            parsed_response = JSON.parse(response.body)
            info_json = parsed_response
            expect(info_json.keys).to match_array(["id", "content", "answered_at", "formulary_id", "question_id", "visit_id", "created_at", "updated_at"])
          end

          it "Get answer index sucess"do
            parsed_response = JSON.parse(response.body)
            info_json = parsed_response
            expect(info_json["content"]).to eq("Resposta da pergunta 2")
          end

          it "Is the really id"do
            parsed_response = JSON.parse(response.body)
            info_json = parsed_response
            expect(info_json["id"]).to eq(answer2.id)
          end
      end
    end

    context "to get answer by index inexistent"do
      describe "GET answers/index", type: :request do
        
        before {get "/answers/#{-1}", headers: { 'Authorization' => 'Bearer ' + auth_token }}
        it "Get answers index fail not found"do
          expect(response).to have_http_status(404)
        end
      end
    end

    context "POST answer create" do
        describe "POST answers", type: :request do
          before { post "/answers", params:{content:answer3[:content], formulary_id:answer3[:formulary_id], question_id:answer3[:question_id], visit_id:answer3[:visit_id]}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
    
          it "sucess when create a new answer"do
            expect(response).to have_http_status(200)
          end
    
          it "creates a new answer" do
            expect(Answer.find_by(content:answer3[:content])).to_not be_nil
          end
        end 
    end

    context "POST answer create invalid" do
      describe "Post answers - invalid atributtes", type: :request do
          # criando um answer sem algum id
          before {post "/answers", params:{content: answer3[:content], formulary_id:answer3[:formulary_id], visit_id:answer3[:visit_id]}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
        
          it"failed with create a answer"do
              #byebug
              expect(response).to have_http_status(422)
          end
  
          it "answers dont exist"do
            expect(Answer.find_by(content: answer3[:content])).to be_nil
          end
      end
    end

    context "Update a answer by id"do
      describe "Update answer sucessful", type: :request do
          before { patch answer_path(answer), params: { content: "Meu nome é Leo", formulary_id:answer[:formulary_id], visit_id:answer[:visit_id]}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
          it "ok status"do
            expect(response).to have_http_status(200)
          end
          it "update sucessful example by name"do
            parsed_response = JSON.parse(response.body)
            info_json = parsed_response
            expect(info_json["content"]).to eq("Meu nome é Leo")
        end
      end
    end

    context "Delete a answer by id"do
        describe "Update answer sucessful", type: :request do
            before { delete answer_path(answer2), headers: { 'Authorization' => 'Bearer ' + auth_token }}
            it "ok status delete"do
              expect(response).to have_http_status(200)
            end

            it "not found deleted answer"do
              expect(Answer.find_by(id:answer2.id)).to be_nil
            end
        end
    end

end