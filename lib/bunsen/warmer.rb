require_relative 'mongo_client'

module Bunsen
  class Warmer
    attr_reader :database
    attr_reader :collections
    attr_reader :indexes

    def initialize(database, collections = [], indexes = [], options = {})
      @options = {
        host: "localhost",
        port: 27017
      }.merge(options)

      @database = database
      @collections = collections
      @indexes = indexes

      @mongo_client = Bunsen::MongoClient.new(database, @options)
    end

    def touch_each_collection
      collections = @collections.any? ? @collections : @mongo_client.collections
      collections.each_with_index do |collection, enum_index|
        yield @mongo_client.touch_data_in(collection), enum_index + 1, collections.count
      end
    end

    def touch_each_index
      indexes = @indexes.any? ? @indexes : @mongo_client.collections
      indexes.each_with_index do |collection, enum_index|
        yield @mongo_client.touch_index_in(collection), enum_index + 1, indexes.count
      end
    end
  end
end
