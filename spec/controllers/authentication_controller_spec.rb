require 'rails_helper'
require 'factory_bot'
require 'json'

RSpec.describe AuthenticationController, type: :controller do

    let!(:user) {FactoryBot.create(:user)}

    context "Authenticate sucess" do
        describe "POST authenticate", type: :request do
          before { post "/authenticate", params:{ email: user[:email], password:"senha123"} }
    
          it "sucess when login"do
            expect(response).to have_http_status(200)
          end

          it "returns a auth_token"do
            parsed_response = JSON.parse(response.body)
            expect(parsed_response).to include("auth_token")
            p response.body
          end

        end 
    end

    context "Authenticate fail" do
        describe "POST authenticate fail", type: :request do
          before { post "/authenticate", params:{ email: user[:email], password:"senha errada"} }
    
          it "fail when login"do
            expect(response).to have_http_status(401)
          end
        end 
    end
    
end
