require 'hammer_cli/messages'

module HammerCLIForeman

  module Parameter

    def self.get_parameters(resource_type, resource_id)
      params = {
        "#{resource_type}_id" => resource_id
      }

      params = HammerCLIForeman.foreman_resource(:parameters).call(:index, params)
      HammerCLIForeman.collection_to_common_format(params)
    end


    class AbstractParameterCommand < HammerCLIForeman::Command

      def self.parameter_resource
        HammerCLIForeman.foreman_resource(:parameters)
      end

      def parameter_resource
        self.class.parameter_resource
      end

      def get_identifier
        @identifier ||= get_resource_id(resource, :scoped => true)
        @identifier
      end

      def get_parameter_identifier
        if @parameter_identifier.nil?
          opts = all_options
          opts[HammerCLI.option_accessor_name("#{resource.singular_name}_id")] ||= get_identifier
          @parameter_identifier = resolver.send("#{parameter_resource.singular_name}_id", opts)
        end
        @parameter_identifier
      end

      def base_action_params
        {
          "#{resource.singular_name}_id" => get_identifier
        }
      end

      def self.custom_option_builders
        [
          DependentSearchablesOptionBuilder.new(resource, searchables)
        ]
      end

    end


    class SetCommand < AbstractParameterCommand
      option "--name", "NAME", _("parameter name"), :required => true
      option "--value", "VALUE", _("parameter value"), :required => true

      def self.command_name(name=nil)
        (super(name) || "set-parameter").gsub('_', '-')
      end

      def execute
        if parameter_exist?
          update_parameter
          print_message success_message_for :update if success_message_for :update
        else
          create_parameter
          print_message success_message_for :create if success_message_for :create
        end
        HammerCLI::EX_OK
      end

      def parameter_exist?
        get_parameter_identifier rescue false
      end

      def update_parameter
        params = {
          "id" => get_parameter_identifier,
          "parameter" => {
            "value" => option_value
          }
        }.merge(base_action_params)
        HammerCLIForeman.record_to_common_format(parameter_resource.call(:update, params))
      end

      def create_parameter
        params = {
          "parameter" => {
            "name" => option_name,
            "value" => option_value
          }
        }.merge(base_action_params)

        HammerCLIForeman.record_to_common_format(parameter_resource.call(:create, params))
      end

    end


    class DeleteCommand < AbstractParameterCommand
      option "--name", "NAME", _("parameter name"), :required => true

      def self.command_name(name=nil)
        (super(name) || "delete-parameter").gsub('_', '-')
      end

      def execute
        params = {
          "id" => get_parameter_identifier
        }.merge base_action_params

        HammerCLIForeman.record_to_common_format(parameter_resource.call(:destroy, params))
        print_message success_message if success_message
        HammerCLI::EX_OK
      end

    end

  end
end


