require 'hammer_cli_foreman/image'

module HammerCLIForeman

  class ComputeResource < HammerCLIForeman::Command
    resource :compute_resources

    class ListCommand < HammerCLIForeman::ListCommand

      output do
        field :id, _("Id")
        field :name, _("Name")
        field :provider, _("Provider")
      end

      build_options
    end


    class InfoCommand < HammerCLIForeman::InfoCommand
      PROVIDER_SPECIFIC_FIELDS = {
        'ovirt' => [
          Fields::Field.new(:label => _('UUID'), :path => ["compute_resource", "uuid"])
        ],
        'ec2' => [
          Fields::Field.new(:label => _('Region'), :path => ["compute_resource", "region"])
        ],
        'vmware' => [
          Fields::Field.new(:label => _('UUID'), :path => ["compute_resource", "uuid"]),
          Fields::Field.new(:label => _('Server'), :path => ["compute_resource", "server"])
        ],
        'openstack' => [
          Fields::Field.new(:label => _('Tenant'), :path => ["compute_resource", "tenant"])
        ],
        'rackspace' => [
          Fields::Field.new(:label => _('Region'), :path => ["compute_resource", "region"])
        ],
        'libvirt' => [
        ]
      }

      output ListCommand.output_definition do
        field :url, _("Url")
        field :description, _("Description")
        field :user, _("User")
        HammerCLIForeman::References.taxonomies(self)
        HammerCLIForeman::References.timestamps(self)
      end

      def print_data(data)
        provider = data["provider"].downcase
        output_definition.fields.concat PROVIDER_SPECIFIC_FIELDS[provider]
        super(data)
      end

      build_options
    end


    class CreateCommand < HammerCLIForeman::CreateCommand

      success_message _("Compute resource created")
      failure_message _("Could not create the compute resource")

      build_options

      validate_options do
        all(:option_name, :option_url, :option_provider).required
      end
    end


    class UpdateCommand < HammerCLIForeman::UpdateCommand
      success_message _("Compute resource updated")
      failure_message _("Could not update the compute resource")

      build_options :without => :name
    end


    class DeleteCommand < HammerCLIForeman::DeleteCommand
      success_message _("Compute resource deleted")
      failure_message _("Could not delete the compute resource")

      build_options
    end


    autoload_subcommands
    subcommand 'image', HammerCLIForeman::Image.desc, HammerCLIForeman::Image
  end

end


