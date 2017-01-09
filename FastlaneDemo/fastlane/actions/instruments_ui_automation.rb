module Fastlane
  module Actions
    module SharedValues
      INSTRUMENTS_UI_AUTOMATION_CUSTOM_VALUE = :INSTRUMENTS_UI_AUTOMATION_CUSTOM_VALUE
    end

    class InstrumentsUiAutomationAction < Action

      def self.run(params)
        automation_template_path = ENV["FL_AUTOMATION_TEMPLATE"]
        device = params[:device]
        app_path = params[:app_path]
        script = params[:script]
        report_output_path = params[:report_output_path]
        command = ['set -o pipefail && instruments']
        command << "-t #{automation_template_path}"
        command << "-w #{device} #{app_path}"
        command << "-e UIASCRIPT #{script}"
        command << "-e UIARESULTSPATH #{report_output_path}"

        begin
          Actions.sh command.join(' ')
        rescue => ex
          exit_status = $?.exitstatus

          raise_error = true
          if exit_status.eql? 65
            iphone_simulator_time_out_error = /iPhoneSimulator: Timed out waiting/

            if (iphone_simulator_time_out_error =~ ex.message) != nil
              raise_error = false

              UI.important("First attempt failed with iPhone Simulator error: #{iphone_simulator_time_out_error.source}")
              UI.important("Retrying once more...")
              Action.sh command.join(' ')
            end
          end
          raise ex if raise_error
        end

        Action.sh 'rm -rf instruments*.trace'

        Action.sh 'killall "Simulator"'
      end

      def self.description
        "Xcode instrument command"
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :device,
                                      description: "Device ID"),
          FastlaneCore::ConfigItem.new(key: :app_path,
                                      description: "App Path"),
          FastlaneCore::ConfigItem.new(key: :report_output_path,
                                      description: "Report Output Path"),
          FastlaneCore::ConfigItem.new(key: :script,
                                      description: "Monkey Script Path")
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['INSTRUMENTS_UI_AUTOMATION_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["oysz"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
