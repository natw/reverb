require 'json'
require 'redis'


module Reverb

  class RecordStore
    REDIS_LIST_KEY = 'reverb.records'

    @@redis = Redis.new

    def self.save(records)
      @@redis.pipelined do
        records.each do |r|
          @@redis.rpush(REDIS_LIST_KEY, self.serialize(r))
        end
      end
    end

    def self.all
      @@redis.lrange(REDIS_LIST_KEY, 0, -1).map &method(:deserialize)
    end

    def self.serialize(r)
      JSON.dump(r.to_h)
    end

    def self.deserialize(r)
      JSON.parse(r)
    end
  end
end
