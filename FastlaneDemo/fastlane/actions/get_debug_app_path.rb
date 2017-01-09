module Fastlane
  module Actions
    module SharedValues
      GET_DEBUG_APP_PATH_CUSTOM_VALUE = :GET_DEBUG_APP_PATH_CUSTOM_VALUE
    end

    class GetDebugAppPathAction < Action

      def self.run(params)
        project = params[:project]
        scheme = params[:scheme]
        command = ['xcodebuild']
        command << '-workspace'
        command << "#{project}.xcworkspace"
        command << '-scheme'
        command << "#{scheme}"
        command << '-sdk'
        command << "iphonesimulator10.2"
        command << '-arch'
        command << "x86_64"
        command << '-configuration Debug -showBuildSettings | grep CONFIGURATION_BUILD_DIR'
        output_result = Actions.sh command.join(' ')
        configure = output_result.match(/CONFIGURATION_BUILD_DIR = (.*)/i).captures
        File.join(configure[0],"#{scheme}.app")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Get Xcode build app path of simlulator's debug enviroment"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: project,
                                      description: "project name",
                                      is_string: true),
          FastlaneCore::ConfigItem.new(key: scheme,
                                      description: "scheme name",
                                      is_string: true)
        ]
      end

      def self.output
      end

      def self.return_value
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
