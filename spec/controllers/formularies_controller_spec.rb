require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe FormulariesController, type: :controller do
    
    let(:user) { FactoryBot.create(:user) }
    let(:visit){ FactoryBot.create(:visit, user_id:user.id)}
    let!(:formulary) {FactoryBot.create(:formulary, visit_id: visit.id)}

    let(:formulary2) { FactoryBot.attributes_for(:formulary2, visit_id:visit.id)}

    let!(:formulary3) {FactoryBot.create(:formulary3, visit_id: visit.id)}

    let!(:auth_token) { JsonWebToken.encode(user_id: user.id) }

    context "GET all formularies"do
        describe"GET all formularies", type: :request do     
            before { get "/formularies", headers: { 'Authorization' => 'Bearer ' + auth_token } }

            it "Get formularies all sucess"do
                #byebug
                expect(response).to have_http_status(200)
            end

            it "Get formulary keys sucess"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json.first.keys).to match_array(["id", "name", "visit_id", "created_at", "updated_at"])
            end

            it "Get formularies parameters sucess"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json.first["name"]).to eq("Formulario 1")
            end
        end
    end

    context "to get formulary by index"do
        describe "GET formulary/index", type: :request do
        
            before {get "/formularies/#{formulary.id}", headers: { 'Authorization' => 'Bearer ' + auth_token }}
            
            it "Get formularies index sucess"do
                expect(response).to have_http_status(200)
            end
            
            it "Get formulary params key sucess"do
                #byebug
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json.keys).to match_array(["id", "name", "visit_id", "created_at", "updated_at"])
            end

            it "Get formulary index sucess"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json["name"]).to eq("Formulario 1")
            end

            it "Is the really id"do
                parsed_response = JSON.parse(response.body)
                info_json = parsed_response
                expect(info_json["id"]).to eq(formulary.id)
            end
        end
    end

    context "formulary POST"do
        before {post "/formularies", params:{name:formulary2[:name], visit_id: visit.id}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
            describe"sucess formulary create", type: :request do
            
            it"formulary sucess response"do
                expect(response).to have_http_status(200)
            end 
            
            it"formulary name exist"do
                expect(Formulary.find_by(name:formulary2[:name])).to_not be_nil 
            end

            it "belongs to a visit" do
                form = Formulary.last
                expect(form.visit).to eq(visit)
            end
        end
    end

    context "formulary POST fail"do
        before {post "/formularies", params:{name:nil, visit_id: visit.id}, headers: { 'Authorization' => 'Bearer ' + auth_token }}
            describe"fail formulary create", type: :request do
            
            it"formulary fail response - unprocessabele"do
                expect(response).to have_http_status(422)
            end 
        end
    end

    context "Update a formulary by id"do
            describe "Update formulary sucessful", type: :request do
                before { patch formulary_path(formulary), params: { name:"Formulario nome alterado", visit_id: visit.id }, headers: { 'Authorization' => 'Bearer ' + auth_token }}
                it "ok status"do
                    expect(response).to have_http_status(200)
                end
                it "update sucessful example by name"do
                    parsed_response = JSON.parse(response.body)
                    info_json = parsed_response
                    expect(info_json["name"]).to eq("Formulario nome alterado")
                end
            end
    end

    context "Delete a formulary by id"do
        describe "Update formulary sucessful", type: :request do
            before { delete formulary_path(formulary3), headers: { 'Authorization' => 'Bearer ' + auth_token }}
            it "ok status delete"do
                expect(response).to have_http_status(200)
            end

            it "not found deleted formulary"do
                expect(Formulary.find_by(id:formulary3.id)).to be_nil
            end
        end
    end

end