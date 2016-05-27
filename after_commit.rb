module Sirportly
  module Modules
    module Custom
      class AfterCommit < Module
        module_name "AfterCommit"
        description "Sends an HTTP request to an endpoint after a ticket is updated"
        author "Peter Choo <pchoo@centiq.co.uk>"

        public_description "Fires a request to an endpoint on Ticket and Ticket Update events.  If an endpoint is required and an event endpoint is left blank, that event will not trigger."

        config_option :refresh_url, "MicroService URL", "The URL for the endpoints", :required => true

        config_option :require_endpoint, "Require an Endpoint?", "If Yes, any event endpoints left blank will not trigger. If No, any endpoints left blank will call the base URL", :required => true, :options => ['Yes', 'No']

        config_option :ticket_create_endpoint, "Ticket Create endpoint", "The endpoint to call when a Ticket is created"
        config_option :ticket_update_endpoint, "Ticket Update endpoint", "The endpoint to call when a Ticket is updated"
        config_option :ticket_destroy_endpoint, "Ticket Destroy endpoint", "The endpoint to call when a Ticket is destroyed"
        config_option :ticket_update_create_endpoint, "Ticket Update Create endpoint", "The endpoint to call when a Ticket Update is created"
        config_option :ticket_update_update_endpoint, "Ticket Update Update endpoint", "The endpoint to call when a Ticket Update is updated"
        config_option :ticket_update_destroy_endpoint, "Ticket Update Destroy endpoint", "The endpoint to call when a Ticket Update is destroyed"

        config_option :query_string, "Query String", "If supplied, the query string will be supplied to the URL"

        # Publicise makes the configuration options appear in the web interface for configuring
        publicise

        add_callback :after, :ticket_update, :create do |config, ticket_update|
          make_request(config, :ticket_update_create_endpoint, ticket_update.ticket)
        end

        add_callback :after, :ticket_update, :update do |config, ticket_update|
          make_request(config, :ticket_update_update_endpoint, ticket_update.ticket)
        end

        add_callback :after, :ticket_update, :destroy do |config, ticket_update|
          make_request(config, :ticket_update_destroy_endpoint, ticket_update.ticket)
        end

        add_callback :after, :ticket, :create do |config, ticket|
          make_request(config, :ticket_create_endpoint, ticket)
        end

        add_callback :after, :ticket, :update do |config, ticket|
          make_request(config, :ticket_update_endpoint, ticket)
        end

        add_callback :after, :ticket, :destroy do |config, ticket|
          make_request(config, :ticket_destroy_endpoint, ticket)
        end

        # Add self. to make this a class method
        def self.check_config(config, event)
          uri = URI.parse(config[:refresh_url])
          uri.is_a?(URI::HTTP) && ((config[:require_endpoint] == 'No') || !config[event].blank?)
        end

        # Add self. to make this a class method
        def self.make_request(config, event, ticket)
          if check_config(config, event)
            uri = "#{config[:refresh_url]}"
            if !config[event].blank?
              uri.sub(/\/$/, '')
              uri << "/#{config[event]}"
            end
            uri << ( config[:query_string].blank? ? "" : "?#{config[:query_string]}" )
            ticket_payload = "{\"id\":#{ticket.id}}"
            Sirportly::HTTP.post(uri, {ticket: ticket_payload})
          end
        end
      end
    end
  end
end
