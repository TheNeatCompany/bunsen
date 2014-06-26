require 'mongo'
require 'bson'

module Bunsen
  class MongoClient
    include Mongo

    def initialize(database, options = {})
      @options = {
        host: "localhost",
        port: 27017
      }.merge(options)

      @client = Mongo::MongoClient.new(@options[:host], @options[:port], slave_ok: true)
      @database = @client[database]
    end

    def touch(collection, touch_type = :both)
      should_touch_data = [:data, :both].include?(touch_type.to_sym)
      should_touch_index = [:index, :both].include?(touch_type.to_sym)

      @database.command(
        touch: collection,
        data: should_touch_data,
        index: should_touch_index
      )
    end

    def touch_data_in(collection)
      touch(collection, :data)
    end

    def touch_index_in(collection)
      touch(collection, :index)
    end
  end
end
