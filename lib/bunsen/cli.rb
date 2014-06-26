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
    
    option :host, default: "localhost"
    option :port, type: :numeric, default: 27017
    option :database, required: true
    option :collections, type: :array, default: []
    option :indexes, type: :array, default: []
    
    def warm
      warmer = Bunsen::Warmer.new(
        options[:database],
        options[:collections],
        options[:indexes],
        host: options[:host],
        port: options[:port],
      )

      Formatador.display_line "[cyan]#{Bunsen::version_string}[/] warming mongodb://#{options[:host]}:#{options[:port]}/#{options[:database]}"
      
      Formatador.display_line "[yellow]warming data:[/] #{options[:collections].join(' ')}"
      warmer.touch_each_collection do |_, completed_count, remaining_count|
        Formatador.redisplay_progressbar(
          completed_count,
          remaining_count,
          color: "red"
        )
      end

      Formatador.display_line "[yellow]warming indexes:[/] #{options[:indexes].join(' ')}"
      warmer.touch_each_index do |_, completed_count, remaining_count|
        Formatador.redisplay_progressbar(
          completed_count,
          remaining_count,
          color: "red"
        )
      end

      Formatador.display_line "[green]all done![/]"      
    end
  end
end
