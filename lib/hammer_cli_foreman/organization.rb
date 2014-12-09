require 'hammer_cli_foreman/resource_supported_test'

module HammerCLIForeman

  class Organization < HammerCLIForeman::Command

    resource :organizations

    class ListCommand < HammerCLIForeman::ListCommand
      include HammerCLIForeman::ResourceSupportedTest

      output do
        field :id, _("Id")
        field :name, _("Name")
      end

      build_options
    end


    class InfoCommand < HammerCLIForeman::InfoCommand
      include HammerCLIForeman::ResourceSupportedTest

      option "--id", "ID", " "

      output ListCommand.output_definition do
        HammerCLIForeman::References.users(self)
        HammerCLIForeman::References.smart_proxies(self)
        HammerCLIForeman::References.subnets(self)
        HammerCLIForeman::References.compute_resources(self)
        HammerCLIForeman::References.media(self)
        HammerCLIForeman::References.config_templates(self)
        HammerCLIForeman::References.domains(self)
        HammerCLIForeman::References.environments(self)
        HammerCLIForeman::References.hostgroups(self)
        HammerCLIForeman::References.parameters(self)
        collection :locations, _("Locations"), :numbered => false, :hide_blank => true do
          custom_field Fields::Reference
        end
        HammerCLIForeman::References.timestamps(self)
      end


      build_options do |o|
        o.expand.primary(:organizations)
      end
    end


    class CreateCommand < HammerCLIForeman::CreateCommand
      include HammerCLIForeman::ResourceSupportedTest

      success_message _("Organization created")
      failure_message _("Could not create the organization")

      build_options
    end


    class UpdateCommand < HammerCLIForeman::UpdateCommand
      include HammerCLIForeman::ResourceSupportedTest

      option "--id", "ID", " "

      success_message _("Organization updated")
      failure_message _("Could not update the organization")

      build_options
    end


    class DeleteCommand < HammerCLIForeman::DeleteCommand
      include HammerCLIForeman::ResourceSupportedTest

      option "--id", "ID", " "

      success_message _("Organization deleted")
      failure_message _("Could not delete the organization")

      build_options do |o|
        o.expand.primary(:organizations)
      end
    end


    HammerCLIForeman::AssociatingCommands::Hostgroup.extend_command(self)
    HammerCLIForeman::AssociatingCommands::Environment.extend_command(self)
    HammerCLIForeman::AssociatingCommands::Domain.extend_command(self)
    HammerCLIForeman::AssociatingCommands::Medium.extend_command(self)
    HammerCLIForeman::AssociatingCommands::Subnet.extend_command(self)
    HammerCLIForeman::AssociatingCommands::ComputeResource.extend_command(self)
    HammerCLIForeman::AssociatingCommands::SmartProxy.extend_command(self)
    HammerCLIForeman::AssociatingCommands::User.extend_command(self)
    HammerCLIForeman::AssociatingCommands::ConfigTemplate.extend_command(self)

    autoload_subcommands
  end

end



