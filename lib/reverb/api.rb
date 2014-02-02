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
        RecordStore.save(RecordParser.new(params[:record]).hashes)
        'thanks'
      end

      desc "get records sorted by gender"
      get :gender do
        RecordReader.sort(RecordStore.all, 1)
      end

      desc "get records sorted by birthdate"
      get :birthdate do
        RecordReader.sort(RecordStore.all, 2)
      end

      desc "get records sorted by name"
      get :name do
        RecordReader.sort(RecordStore.all, 3)
      end
    end
  end
end
