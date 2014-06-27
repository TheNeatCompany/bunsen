require_relative 'mongo_client'
require 'chronic'

module Bunsen
  class Warmer
    attr_reader :database
    attr_reader :collections
    attr_reader :indexes

    def initialize(database, collections = [], indexes = [], options = {})
      @options = {
        host: "localhost",
        port: 27017,
        not_before: nil
      }.merge(options)

      @database = database
      @collections = collections
      @indexes = indexes

      @mongo_client = Bunsen::MongoClient.new(database, @options)
      @all_collections_in_db = @mongo_client.collections
    end

    def touch_each_collection
      collections = @collections.any? ? @collections : @all_collections_in_db
      collections.each_with_index do |collection, enum_index|
        if @options[:not_before]
          yield @mongo_client.touch_data_since(collection, not_before_nl_to_time), enum_index + 1, collections.count
        else
          yield @mongo_client.touch_data_in(collection), enum_index + 1, collections.count
        end
      end
    end

    def touch_each_index
      indexes = @indexes.any? ? @indexes : @all_collections_in_db
      indexes.each_with_index do |collection, enum_index|
        yield @mongo_client.touch_index_in(collection), enum_index + 1, indexes.count
      end
    end


    private

    def not_before_nl_to_time
      Chronic.parse(@options[:not_before]) or raise "can't make sense of time"
    end
  end
end
