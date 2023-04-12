require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe VisitsController, type: :controller do
    
    let!(:user){FactoryBot.create(:user)}
    let!(:user2){FactoryBot.create(:user2)}
    let!(:visit){FactoryBot.attributes_for(:visit)}
    let!(:visit2){FactoryBot.attributes_for(:visit)}
    let!(:visit_create){FactoryBot.create(:visit, user_id: user.id)}
    let!(:visit_create2){FactoryBot.create(:visit2, user_id: user2.id)}
    let!(:visit_create3){FactoryBot.create(:visit3, user_id: user2.id)}
    
    let!(:auth_token) { JsonWebToken.encode(user_id: user.id) }

    context "GET visit all sucess"do
        describe "GET visits sucess by index", type: :request do
            #byebug
            before {get "/visits", headers: { 'Authorization' => 'Bearer ' + auth_token }}
            
            it "request sucess"do
                expect(response).to have_http_status(200)
            end
        end
    end

    context "GET visit by index sucess"do
        describe "GET visits sucess by index", type: :request do
            #byebug
            before {get "/visits/#{visit_create.id}", headers: { 'Authorization' => 'Bearer ' + auth_token }}
            
            it "request sucess"do
                expect(response).to have_http_status(200)
            end

            it "Get visits params key sucess"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                #byebug
                expect(info_json.keys).to match_array(["id", "data", "status", "checkin_at", "checkout_at", "created_at", "updated_at", "user_id"])
            end
  
            it "Get user index sucess"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json["data"]).to eq("2024-03-16T13:06:45.868Z")
            end

            it "Is the really id"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json["id"]).to eq(visit_create.id)
            end

        end
    end

    context "GET visit by index inexistent - fail"do
        describe "GET visits fail by index", type: :request do
            before {get "/users/#{59}", headers: { 'Authorization' => 'Bearer ' + auth_token }}
            
            it "Not found error index inexistent"do
                expect(response).to have_http_status(404)
            end

        end
    end

    context "POST visit sucess"do
        describe "create visit sucess", type: :request do                        
            before {post "/visits", params:{data:visit[:data], status: visit[:status], checkin_at:visit[:checkin_at], checkout_at:visit[:checkout_at], user_id: user[:id]}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
            
            it "sucess when create a new visit"do
                expect(response).to have_http_status(200)
            end

            it "sucess and was created a new id"do
                visit = Visit.last
                expect(Visit.find_by(id:visit[:id])).to_not be_nil
            end

            it "visits belongs to a user" do
                visit_of_post = Visit.last
                expect(visit_of_post.user).to eq(user)
            end
        end
    end

    context "POST visit fail"do
        describe "create visit fail", type: :request do                        
            # create without any attribute
            before {post "/visits", params:{data:visit2[:data], checkin_at:visit2[:checkin_at], checkout_at:visit2[:checkout_at], user_id: user[:id]}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
            
            it "fail when create a new visit"do
                # when it is without user_id or status return 422, when it is without data, checkin or checkout return 500
                expect(response).to have_http_status(422) or have_http_status(500)
            end

            it "fail and wasnt created a new id"do
                visit = Visit.first
                expect(Visit.find_by(id:visit2[:id])).to be_nil
            end
        end
    end

    context "Update a visit by id"do
        describe "Update visit sucessful", type: :request do
            before { patch visit_path(visit_create2), params: {data:visit_create2[:data], status: "REALIZADO", checkin_at:visit_create2[:checkin_at], checkout_at:visit_create2[:checkout_at], user_id: user2[:id]}, headers: { 'Authorization' => 'Bearer ' + auth_token }}

            it "ok status"do
                #byebug
                expect(response).to have_http_status(200)
            end
            it "update sucessful example by status"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json["status"]).to eq("REALIZADO")
            end
        end
    end

    context "Delete a visit by id"do
        describe "Update visit sucessful", type: :request do
            before { delete visit_path(visit_create3), headers: { 'Authorization' => 'Bearer ' + auth_token }}
            it "ok status delete"do
                expect(response).to have_http_status(200)
            end
            
            it "not found deleted visit"do
                get "/visits/#{visit_create3.id}", headers: { 'Authorization' => 'Bearer ' + auth_token }
                expect(response).to have_http_status(404)
            end
        end
    end
end