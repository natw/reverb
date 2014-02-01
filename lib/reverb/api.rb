require 'grape'

module Reverb
  class API < Grape::API
    format :txt

    resource :records do
      desc "create a record"
      params do
        requires :record, type: String, desc: "the record, comma/space/pipe separated"
      end
      post do
        RecordStore.save(RecordParser.new(params[:record]))
        'thanks'
      end

      desc "get records sorted by gender"
      get :gender do
        RecordStore.all
      end

      desc "get records sorted by birthdate"
      get :birthdate do
        'birthdate'
      end

      desc "get records sorted by name"
      get :name do
        'name'
      end
    end
  end
end
