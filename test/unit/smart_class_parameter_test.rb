require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'apipie_resource_mock')

require 'hammer_cli_foreman/smart_class_parameter'

describe HammerCLIForeman::SmartClassParameter do

  include CommandTestHelper

  context "ListCommand" do

    before :each do
      ResourceMocks.smart_class_parameters_index
    end

    let(:cmd) { HammerCLIForeman::SmartClassParameter::ListCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "no arguments"
      it_should_accept "hostgroup id", ["--hostgroup-id=1"]
      it_should_accept "host id", ["--host-id=1"]
      it_should_accept "environment id", ["--environment-id=1"]
      it_should_accept "puppet class id", ["--puppet-class-id=1"]
      it_should_accept_search_params
    end

    context "output" do
      let(:expected_record_count) { cmd.resource.call(:index).length }

      it_should_print_n_records
      it_should_print_column "Id"
      it_should_print_column "Class Id"
      it_should_print_column "Puppet class"
      it_should_print_column "Parameter"
      it_should_print_column "Default Value"
      it_should_print_column "Override"
    end

  end


  context "InfoCommand" do

    before :each do
      ResourceMocks.smart_class_parameters_show
    end

    let(:cmd) { HammerCLIForeman::SmartClassParameter::InfoCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "id", ["--id=1"]
      it_should_accept "name", ["--name=param"]
      # it_should_fail_with "no arguments"
      # TODO: temporarily disabled, parameters are checked in the id resolver
    end
  end


  context "UpdateCommand" do

    let(:cmd) { HammerCLIForeman::SmartClassParameter::UpdateCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "id", ["--id=1"]
      it_should_accept "override", ["--id=1","--override=true"]
      it_should_accept "description", ["--id=1","--description=descr"]
      it_should_accept "default-value", ["--id=1","--default-value=1"]
      it_should_accept "path  ", ["--id=1","--path=path"]
      it_should_accept "validator-type", ["--id=1","--validator-type=list"]
      it_should_accept "validator-rule ", ["--id=1","--validator-rule=''"]
      it_should_accept "override-value-order", ["--id=1","--override-value-order=fqdn"]
      it_should_accept "parameter-type ", ["--id=1","--parameter-type=string"]
      it_should_accept "required", ["--id=1","--required=true"]

      # it_should_fail_with "no params", []
      # TODO: temporarily disabled, parameters are checked in the id resolver
    end

  end


end
