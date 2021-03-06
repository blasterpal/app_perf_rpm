module AppPerfRpm
  class Monitoring
    class << self
      def load
        pattern = File.join(File.dirname(__FILE__), 'monitors', '**', '*.rb')
        Dir.glob(pattern) do |f|
          begin
            require f
          rescue => e
            AppPerfRpm.logger.error "Error loading monitor file '#{f}' : #{e}"
            AppPerfRpm.logger.debug "#{e.backtrace.first}"
          end
        end
      end
    end

    def monitors
      @monitors ||= ::AppPerfRpm::Monitors::Base
        .descendants
        .map(&:new)
    end

    def tick
      monitors.each(&:tick)
    end
  end
end
