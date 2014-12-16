module NetSuiteRails
  class PollManager

    class << self

      def attach(klass)
        @record_sync ||= []
        @list_sync ||= []

        if klass.include? RecordSync
          @record_sync << klass
        elsif klass.include? ListSync
          @list_sync << klass
        end
      end

      def sync(opts = {})
        @record_sync.each do |klass|
          sync_frequency = klass.netsuite_sync_options[:frequency] || 1.day

          if sync_frequency == :never
            Rails.logger.info "Not syncing #{klass.to_s}"
            next
          end

          Rails.logger.info "NetSuite: Syncing #{klass.to_s}"
          
          preference = PollTimestamp.where(key: "netsuite_poll_#{klass.to_s.downcase}timestamp").first_or_initialize

          # check if we've never synced before
          if preference.new_record?
            klass.netsuite_poll({ import_all: true }.merge(opts))
          else
            # TODO look into removing the conditional parsing; I don't think this is needed
            last_poll_date = preference.value
            last_poll_date = DateTime.parse(last_poll_date) unless last_poll_date.is_a?(DateTime)

            if DateTime.now - last_poll_date > sync_frequency
              Rails.logger.info "NetSuite: Syncing #{klass} modified since #{last_poll_date}"
              klass.netsuite_poll({ last_poll: last_poll_date }.merge(opts))
            else
              Rails.logger.info "NetSuite: Skipping #{klass} because of syncing frequency"
            end
          end

          preference.value = DateTime.now
          preference.save!
        end

        @list_sync.each do |klass|
          Rails.logger.info "NetSuite: Syncing #{klass}"
          klass.netsuite_poll
        end
      end
    end

  end
end
