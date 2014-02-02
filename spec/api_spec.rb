require 'spec_helper'
require 'rack/test'

describe Reverb::API do
  include Rack::Test::Methods

  def app
    Reverb::API
  end

  let (:records) {
    [
      {last_name: 'a', first_name: 'asdf', favorite_color: 'red', birthday: Date.new(4,5,6), sex: 'M'},
      {last_name: 'o', first_name: 'asdf', favorite_color: 'red', birthday: Date.new(5,6,7), sex: 'M'},
      {last_name: 'l', first_name: 'asdf', favorite_color: 'red', birthday: Date.new(3,4,5), sex: 'F'},
      {last_name: 'x', first_name: 'asdf', favorite_color: 'red', birthday: Date.new(7,8,9), sex: 'F'},
    ]
  }

  describe "POST /records" do
    it "requires a record param" do
      post "/records"
      expect(last_response.status).to eq 400
    end

    it "saves records" do
      expect(Reverb::RecordStore).to receive(:save)
      post "/records", {record: "lastname, firstname, M, red, 1950/1/2"}
      expect(last_response.status).to eq 201
    end
  end

  describe 'the GETs' do
    before :each do
      expect(Reverb::RecordStore).to receive(:redis).at_least(1).times {
        double(:lrange => records.map { |x| JSON.dump x })
      }
    end
    describe "GET /records/gender" do
      it "works" do
        get '/records/gender'
      end
    end

    describe "GET /records/birthdate" do
      it "works" do
        get '/records/birthdate'
      end
    end

    describe "GET /records/name" do
      it "works" do
        get 'records/name'
      end
    end
  end
end
