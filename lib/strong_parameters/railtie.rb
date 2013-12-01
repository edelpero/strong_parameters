require 'rails/railtie'

module StrongParameters
  class Railtie < ::Rails::Railtie
    if config.respond_to?(:app_generators)
      config.app_generators.scaffold_controller = :strong_parameters_controller
    else
      config.generators.scaffold_controller = :strong_parameters_controller
    end

    initializer "strong_parameters.config", :before => "action_controller.set_configs" do |app|
      ActionController::Parameters.action_on_unpermitted_parameters = app.config.action_controller.delete(:action_on_unpermitted_parameters) do
        raise_on_development || log_on_test || false
      end
    end

    private

      def raise_on_development
        :raise if Rails.env.development?
      end

      def log_on_test
        :log if Rails.env.test?
      end
  end
end
