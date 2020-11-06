# frozen_string_literal: true

require "test_helper"
require "generators/boring/active_storage/azure/install/install_generator"

class AzureActiveStorageInstallGeneratorTest < Rails::Generators::TestCase
  tests Boring::ActiveStorage::Azure::InstallGenerator
  setup :build_app
  teardown :teardown_app

  include GeneratorHelper

  def destination_root
    app_path
  end

  def test_should_configure_azure_for_active_storage
    Dir.chdir(app_path) do
      quietly { run_generator }

      assert_file "Gemfile" do |content|
        assert_match(/azure-storage-blob/, content)
      end

      assert_file "config/environments/production.rb" do |content|
        assert_match("config.active_storage.service = :microsoft", content)
        assert_no_match("config.active_storage.service = :local", content)
      end
    end
  end

  def test_should_skip_active_storage
    Dir.chdir(app_path) do
      quietly { run_generator [destination_root, "--skip_active_storage"] }

      assert_no_migration "db/migrate/create_active_storage_tables.active_storage.rb"
    end
  end
end
