module Sirportly
  module Modules
    module Custom
      class AfterCommit < Module
        module_name "AfterCommit"
        description "Sends an HTTP request to an endpoint after a ticket is updated"
        author "Peter Choo <pchoo@centiq.co.uk>"

        config_option :refresh_url, "MicroService Endpoint", "The URL of the refresh endpoint", :required => true
        config_option :auth_user, "Authorisation User", "The User to authenticate as to the MicroService", :required => true
        config_option :auth_key, "Authorisation Key", "The Authorisation Key for the MicroService", :required => true

        # Publicise makes the configuration options appear in the web interface for configuring
        publicise

        add_callback :after, :ticket_update, :update do |config, ticket_update|
          make_request(config, ticket_update.ticket)
        end

        add_callback :after, :ticket, :create do |config, ticket|
          make_request(config, ticket)
        end

        add_callback :after, :ticket, :update do |config, ticket|
          make_request(config, ticket)
        end

        add_callback :after, :ticket, :destroy do |config, ticket|
          make_request(config, ticket)
        end

        # Add self. to make this a class method
        def self.check_config(config)
          uri = URI.parse(config[:refresh_url])
          uri.is_a?(URI::HTTP) && !config[:auth_user].blank? && !config[:auth_key].blank?
        end

        # Add self. to make this a class method
        def self.make_request(config, ticket)
          if check_config(config)
            uri = "#{config[:refresh_url]}?auth=#{config[:auth_user]}:#{config[:auth_key]}"
            ticket_payload = "{\"id\":#{ticket.id}}"
            Sirportly::HTTP.post(uri, {ticket: ticket_payload})
          end
        end
      end
    end
  end
end

