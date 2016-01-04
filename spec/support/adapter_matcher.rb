module Rspec
  module AdapterHelpers
    def self.included(receiver)
      receiver.extend         ExampleGroupMethods
    end

    module ExampleGroupMethods
      def adapter(msg, opts = {})
        opts[:get_times] ||= 0
        opts[:set_times] ||= 0
        opts[:set_value] ||= false
        opts[:delete_times] ||= 0
        msg ||= 'no message provided'

        it "adapter #{msg}" do
          expect(@adapter).to(
            have_received(:get_value).with(anything()).exactly(opts[:get_times]).times
          )
          expect(@adapter).to(
            have_received(:set_value).with(
              anything(), opts[:set_value]
            ).exactly(opts[:set_times]).times
          )
          expect(@adapter).to(
            have_received(:delete_value).exactly(opts[:delete_times]).times
          )
        end
      end
    end
  end
end

