module RSpec
  module Rails
    # Container module for routing spec functionality.
    module FeatureExampleGroup
      extend ActiveSupport::Concern
      include RSpec::Rails::RailsExampleGroup

      # Default host to be used in Rails route helpers if none is specified.
      DEFAULT_HOST = "www.example.com"

      included do
        app = ::Rails.application
        if app.respond_to?(:routes)
          include app.routes.url_helpers     if app.routes.respond_to?(:url_helpers)
          include app.routes.mounted_helpers if app.routes.respond_to?(:mounted_helpers)

          if respond_to?(:default_url_options)
            default_url_options[:host] ||= ::RSpec::Rails::FeatureExampleGroup::DEFAULT_HOST
          end
        end
      end

      # Shim to check for presence of Capybara. Will delegate if present, raise
      # if not. We assume here that in most cases `visit` will be the first
      # Capybara method called in a spec.
      def visit(*)
        if defined?(super)
          super
        else
          raise "Capybara not loaded, please add it to your Gemfile:\n\ngem \"capybara\""
        end
      end
    end
  end
end

RSpec.configure do |c|
  c.alias_example_group_to :feature, :type => :feature, :skip => <<-EOT.squish
    Feature specs require the Capybara (http://github.com/jnicklas/capybara)
    gem, version 2.2.0 or later. We recommend version 2.4.0 or later to avoid
    some deprecation warnings and have support for `disable_monkey_patching!`
    mode.
  EOT
  c.alias_example_to :scenario
  c.alias_example_to :xscenario
end
