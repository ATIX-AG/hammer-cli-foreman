require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), 'helpers/resource_disabled')

describe HammerCLIForeman::Location do

  extend CommandTestHelper
  extend ResourceDisabled

  before :each do
    cmd.stubs(:name_to_id).returns(1)
  end

  context "ListCommand" do

    let(:cmd) { HammerCLIForeman::Location::ListCommand.new("", ctx) }

    before :each do
      ResourceMocks.locations_index
    end

    context "parameters" do
      it_should_accept "no arguments"
      it_should_accept_search_params
    end

    context "output" do
      let(:expected_record_count) { cmd.resource.call(:index).length }

      it_should_print_n_records
      it_should_print_column "Name"
      it_should_print_column "Id"
    end

    it_should_fail_when_disabled
  end


  context "InfoCommand" do

    let(:cmd) { HammerCLIForeman::Location::InfoCommand.new("", ctx) }

    before :each do
      ResourceMocks.locations_show
    end

    context "parameters" do
      it_should_accept "id", ["--id=1"]
      it_should_accept "name", ["--name=arch"]
      it_should_fail_with "no arguments"
    end

    context "output" do
      with_params ["--id=1"] do
        it_should_print_n_records 1
        it_should_print_column "Name"
        it_should_print_column "Id"
        it_should_print_column "Created at"
        it_should_print_column "Updated at"
      end
    end

    with_params ["--id=1"] do
      it_should_fail_when_disabled
    end
  end


  context "CreateCommand" do

    let(:cmd) { HammerCLIForeman::Location::CreateCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "name", ["--name=org"]
      it_should_fail_with "name missing", []
    end

    with_params ["--name=loc"] do
      it_should_fail_when_disabled
    end
  end


  context "DeleteCommand" do

    let(:cmd) { HammerCLIForeman::Location::DeleteCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "name", ["--name=org"]
      it_should_accept "id", ["--id=1"]
      it_should_fail_with "name or id missing", []
    end

    with_params ["--id=1"] do
      it_should_fail_when_disabled
    end
  end


  context "UpdateCommand" do

    let(:cmd) { HammerCLIForeman::Location::UpdateCommand.new("", ctx) }

    context "parameters" do
      it_should_accept "name", ["--name=org", "--new-name=org2"]
      it_should_accept "id", ["--id=1", "--new-name=org2"]
      it_should_fail_with "no params", []
      it_should_fail_with "name or id missing", ["--new-name=org2"]
    end

    with_params ["--id=1"] do
      it_should_fail_when_disabled
    end
  end
end
