require File.join(File.dirname(__FILE__), 'test_helper')


describe "parameters" do

  let(:param) do
    {
      "priority" => nil,
      "created_at" => "2015-12-03T01:57:55Z",
      "updated_at" => "2015-12-03T01:57:55Z",
      "id" => 15,
      "name" => "B",
      "value" => "2"
    }
  end

  describe "set" do

    before do
      @cmd = ["organization", "set-parameter"]
    end

    it "should print error on missing --name" do
      params = ['--value=1']

      expected_result = usage_error_result(
        @cmd,
        "option '--name' is required",
        "Could not set organization parameter"
      )

      api_expects_no_call
      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end

    it "should print error on missing --value" do
      params = ['--name=A']

      expected_result = usage_error_result(
        @cmd,
        "option '--value' is required",
        "Could not set organization parameter"
      )

      api_expects_no_call
      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end


    it "should create new parameter" do
      params = ['--name=A', '--value=1', '--organization-id=3']

      api_expects(:parameters, :index, 'Attempt find parameters') do |par|
        par['organization_id'].to_i == 3
      end.returns(index_response([]))
      api_expects(:parameters, :create, 'Create parameter') do |par|
        par['parameter']['name'] == 'A' &&
        par['parameter']['value'] == '1'
      end.returns({:name => 'A', :value => '1'})

      result = run_cmd(@cmd + params)
      assert_cmd(success_result("Parameter [A] created with value [1]\n"), result)
    end


    it "should update existing parameter" do
      params = ['--name=A', '--value=1', '--organization-id=3']

      api_expects(:parameters, :index, 'Find parameter') do |par|
        par['organization_id'].to_i == 3
      end.returns(index_response([param]))
      api_expects(:parameters, :update, 'Update parameter') do |par|
        par['id'].to_i == 15 &&
        par['organization_id'].to_i == 3 &&
        par['parameter']['value'] == '1'
      end.returns({:name => 'A', :value => '1'})

      result = run_cmd(@cmd + params)
      assert_cmd(success_result("Parameter [A] updated to value [1]\n"), result)
    end
  end


  describe "delete" do
    before do
      @cmd = ["organization", "delete-parameter"]
    end

    it "should print error on missing --name" do
      params = []

      expected_result = usage_error_result(
        @cmd,
        "option '--name' is required",
        "Could not delete organization parameter"
      )

      api_expects_no_call
      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end

    it "should print error when the parameter doesn't exist" do
      params = ['--name=A', '--organization-id=3']

      api_expects(:parameters, :index, 'Find parameter') do |par|
        par['organization_id'].to_i == 3
      end.returns(index_response([]))

      expected_result = common_error_result(
        @cmd,
        "parameter not found",
        "Could not delete organization parameter"
      )

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end

    it "should delete the parameter" do
      params = ['--name=A', '--organization-id=3']

      api_expects(:parameters, :index, 'Find parameter') do |par|
        par['organization_id'].to_i == 3
      end.returns(index_response([param]))
      api_expects(:parameters, :destroy, 'Delete parameter') do |par|
        par['id'] == param['id']
      end.returns({:name => 'A', :value => '1'})

      expected_result = success_result(
        "Parameter [A] deleted\n"
      )

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end
  end
end
