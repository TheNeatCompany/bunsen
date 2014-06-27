require 'thor'
require 'formatador'
require_relative '../bunsen'

module Bunsen
  class CLI < Thor
    desc "version", "display version information"
    
    def version
      puts Bunsen::version_string
    end


    desc "warm", "load collections or indexes into memory"
    
    option :database,
      desc: "MongoDB database name",
      required: true
    option :host,
      desc: "MongoDB host name [localhost]",
      default: "localhost"
    option :port,
      desc: "MongoDB connection port [27017]",
      type: :numeric,
      default: 27017
    option :collections,
      desc: "List of collections to read [all]",
      type: :array,
      default: []
    option :indexes,
      desc: "List of indexes to read [all]",
      type: :array,
      default: []
    option :skip_collections,
      desc: "Skip reading collection data",
      type: :boolean
    option :skip_indexes,
      desc: "Skip reading indexes",
      type: :boolean
    option :not_before,
      desc: "Don't read collection data before (date/time in natural language)"
    
    def warm
      if options[:skip_collections] && options[:collections].any?
        say "Choose one: --skip-collections or --collections"
        exit 1
      end

      if options[:skip_indexes] && options[:indexes].any?
        say "Choose one: --skip-indexes or --indexes"
        exit 1
      end

      warmer = Bunsen::Warmer.new(
        options[:database],
        options[:collections],
        options[:indexes],
        host: options[:host],
        port: options[:port],
        not_before: options[:not_before]
      )

      Formatador.display_line "[cyan]#{Bunsen::version_string}[/] warming mongodb://#{options[:host]}:#{options[:port]}/#{options[:database]}"
      
      if options[:not_before]
        Formatador.display_line "[yellow]note:[/] --not-before assumes _id is a BSON::ObjectId and loads its index"
        unless options[:skip_indexes]
          Formatador.display_line "[yellow]note:[/] indexes will be loaded in their entirety without --skip-indexes"
        end
      end

      unless options[:skip_collections]
        Formatador.display_line "[yellow]warming data:[/] #{options[:collections].join(' ')}"
        start_time = Time.now
        warmer.touch_each_collection do |_, completed_count, total_count|
          Formatador.redisplay_progressbar(
            completed_count,
            total_count,
            color: completed_count.eql?(total_count) ? "green" : "red",
            started_at: start_time
          )
        end
      end

      unless options[:skip_indexes]
        Formatador.display_line "[yellow]warming indexes:[/] #{options[:indexes].join(' ')}"
        start_time = Time.now
        warmer.touch_each_index do |_, completed_count, total_count|
          Formatador.redisplay_progressbar(
            completed_count,
            total_count,
            color: completed_count.eql?(total_count) ? "green" : "red",
            started_at: start_time
          )
        end
      end

      Formatador.display_line "[green]all done![/]"      
    end
  end
end
