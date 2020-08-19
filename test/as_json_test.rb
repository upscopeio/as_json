# frozen_string_literal: true

require 'test_helper'

class AsJsonTest < Minitest::Test
  def test_version
    refute_equal nil, AsJson::VERSION
  end

  def test_json_with_attrs_and_methods
    obj = Attrs.new 'John Doe'

    assert_equal({ 'age' => 23, 'email' => 'john@example.com', 'name' => 'John Doe', '_type' => 'attrs' }, obj.as_json)
  end

  def test_json_with_procs_and_lambdas
    obj = ProcsLambdas.new

    assert_equal({ 'api_key' => '123ABC', 'full_name' => 'John Doe', '_type' => 'procs_lambdas' }, obj.as_json)
  end

  def test_json_with_arrays_and_hashes
    obj = ArrayHashes.new

    assert_equal({'people' => ['John', 'Peter', 'Bruce'],
                  'roles' => { 'john' => 'CEO', 'peter' => 'CTO', 'bruce' => 'COO' },
                  '_type' => 'array_hashes' }, obj.as_json)
  end

  def test_json_with_arrays_and_hashes_with_option
    obj = ArrayHashes.new

    assert_equal({'people' => ['John', 'Peter', 'Bruce'],
                  'roles' => { 'john' => 'CEO', 'peter' => 'CTO', 'bruce' => 'COO' },
                  'admin' => true,
                  '_type' => 'array_hashes' }, obj.as_json(with_options: true))
  end

  def test_json_with_arrays_and_hashes_without_option
    obj = ArrayHashes.new

    assert_equal({'roles' => { 'john' => 'CEO', 'peter' => 'CTO', 'bruce' => 'COO' },
                  '_type' => 'array_hashes'}, obj.as_json(without: :people))
  end

  def test_json_with_associations
    team = Team.create(name: 'Acme')
    user = User.create(name: 'John Doe', team: team)

    assert_equal({'name' => 'John Doe',
                  'team' => { 'name' => 'Acme', '_type' => 'team'},
                  '_type' => 'user' }, user.as_json)
  end
end
