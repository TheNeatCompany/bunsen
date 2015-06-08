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
      @admin_database = @client["admin"]
    end

    def collections
    %w(revisions entities accounts users workflow_item_in_processes item_files oauth2.access_tokens ocr_page_counts ocr_texts plan_adds plan_changes)
    end

    def enable_maintenance_mode
      @admin_database.command(replSetMaintenance: true)
    end

    def disable_maintenance_mode
      @admin_database.command(replSetMaintenance: false)
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

    def touch_data_since(collection, time)
      result = {
        "ok" => 0,
        "since" => time,
        "count" => 0
      }

      @database[collection].find(
        _id: { :$gte => time_to_bson_objectid(time) }
      ).each { result["count"] += 1 }

      result["ok"] = 1
      result
    end

    def touch_index_in(collection)
      touch(collection, :index)
    end


    private

    def primary?
      @client.primary?
    end

    def time_to_bson_objectid(time)
      BSON::ObjectId.from_time(time)
    end
  end
end
