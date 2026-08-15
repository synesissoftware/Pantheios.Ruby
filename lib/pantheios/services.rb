# frozen_string_literal: true

Dir[File.join(File.dirname(__FILE__), 'services', '*log_service.rb')].each { |f| require f }

