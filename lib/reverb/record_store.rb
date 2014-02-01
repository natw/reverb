require 'json'
require 'redis'


module Reverb

  class RecordStore
    REDIS_LIST_KEY = 'reverb.records'

    @@redis = Redis.new

    def self.save(record)
      @@redis.rpush(REDIS_LIST_KEY, self.serialize(record))
    end

    def self.all
      @@redis.get(REDIS_LIST_KEY)
    end

    def self.serialize(r)
      JSON.dump(r.to_h)
    end

    def self.deserialize(r)
      JSON.parse(r)
    end
  end
end
