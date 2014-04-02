require File.join(File.dirname(__FILE__), 'test_helper')
require 'hammer_cli'


describe HammerCLIForeman do

  before :each do
    HammerCLI::Settings.load({:_params => {:interactive => false}})
  end

  context "collection_to_common_format" do

    let(:kind) { { "name" => "PXELinux", "id" => 1 } }

    it "should convert old API format" do
      old_format = [
        {
          "template_kind" => kind
        }
      ]

      set = HammerCLIForeman.collection_to_common_format(old_format)
      set.must_be_kind_of HammerCLI::Output::RecordCollection
      set.first.must_equal(kind)
    end

    it "should convert common API format" do
      common_format = [ kind ]

      set = HammerCLIForeman.collection_to_common_format(common_format)
      set.must_be_kind_of HammerCLI::Output::RecordCollection
      set.first.must_equal(kind)
    end

    it "should convert new API format" do
      new_format = {
        "total" => 1,
        "subtotal" => 1,
        "page" => 1,
        "per_page" => 20,
        "search" => nil,
        "sort" => {
          "by" => nil,
          "order" => nil
        },
        "results" => [ kind ]
      }

      set = HammerCLIForeman.collection_to_common_format(new_format)
      set.must_be_kind_of HammerCLI::Output::RecordCollection
      set.first.must_equal(kind)
    end

    it "should rise error on unexpected format" do
      proc { HammerCLIForeman.collection_to_common_format('unexpected') }.must_raise RuntimeError
    end

  end


  context "record_to_common_format" do

    let(:arch) { { "name" => "x86_64", "id" => 1 } }

    it "should convert old API format" do
      old_format = {
        "architecture" => arch
      }

      rec = HammerCLIForeman.record_to_common_format(old_format)
      rec.must_equal(arch)
    end

    it "should convert common API format" do
      common_format = arch

      rec = HammerCLIForeman.record_to_common_format(common_format)
      rec.must_equal(arch)

    end
  end

  context "Create command" do
    it "should format created entity in csv output" do
      ResourceMocks.mock_action_call(:architectures, :create, {
          "architecture" => {
                             "name" => "i386",
                               "id" => 3,
                       "created_at" => "2013-12-16T15:35:21Z",
              "operatingsystem_ids" => [],
                       "updated_at" => "2013-12-16T15:35:21Z"
          }
      })
      arch = HammerCLIForeman::Architecture::CreateCommand.new("", { :adapter => :csv, :interactive => false })
      out, err = capture_io { arch.run(["--name='i386'"]) }
      out.must_match("Message,Id,Name\nArchitecture created,3,i386\n")
    end
  end

  context "AddAssociatedCommand" do
    it "should associate resource" do
      ResourceMocks.mock_action_calls(
          [:organizations, :show, { "id" => 1, "domain_ids" => [2] }],
          [:domains, :show, { "id" => 1, "name" => "local.lan" }])

      class Assoc < HammerCLIForeman::AddAssociatedCommand
        resource :organizations
        associated_resource :domains
        identifiers :id
        apipie_options
      end
      res = Assoc.new("", { :adapter => :csv, :interactive => false })
      res.stubs(:get_identifier).returns([1])
      res.stubs(:associated_id).returns([1])

      res.get_new_ids.sort.must_equal [1, 2]
    end

    it "should associate resource with new format" do
      ResourceMocks.mock_action_calls(
          [:organizations, :show, { "id" => 1, "domains" => [{ "id" => 2, "name" => "global.lan" }] }],
          [:domains, :show, { "id" => 1, "name" => "local.lan" }])

      class Assoc < HammerCLIForeman::AddAssociatedCommand
        resource :organizations
        associated_resource :domains
        apipie_options
      end
      res = Assoc.new("", { :adapter => :csv, :interactive => false })
      res.stubs(:get_identifier).returns([1])
      res.stubs(:associated_id).returns([1])

      res.get_new_ids.sort.must_equal [1, 2]
    end
  end

end
