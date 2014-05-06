module HammerCLIForeman

  class Architecture < HammerCLIForeman::Command

    resource :architectures

    class ListCommand < HammerCLIForeman::ListCommand

      output do
        field :id, _("Id")
        field :name, _("Name")
      end

      build_options
    end


    class InfoCommand < HammerCLIForeman::InfoCommand

      output ListCommand.output_definition do
        field :operatingsystem_ids, _("OS ids"), Fields::List
        field :created_at, _("Created at"), Fields::Date
        field :updated_at, _("Updated at"), Fields::Date
      end

      build_options
    end


    class CreateCommand < HammerCLIForeman::CreateCommand
      success_message _("Architecture created")
      failure_message _("Could not create the architecture")

      build_options
    end


    class DeleteCommand < HammerCLIForeman::DeleteCommand
      success_message _("Architecture deleted")
      failure_message _("Could not delete the architecture")

      build_options
    end


    class UpdateCommand < HammerCLIForeman::UpdateCommand
      success_message _("Architecture updated")
      failure_message _("Could not update the architecture")

      build_options
    end

    HammerCLIForeman::AssociatingCommands::OperatingSystem.extend_command(self)

    autoload_subcommands
  end

end

HammerCLI::MainCommand.subcommand 'architecture', _("Manipulate architectures."), HammerCLIForeman::Architecture

