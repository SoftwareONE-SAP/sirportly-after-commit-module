# AfterCommit SirPortly Module

This module was created to trigger an endpoint on our bespoke system which then queries the SirPortly database.  This has been created as a Module as the Macros run prior to the database transaction commit surrounding updates to tickets and ticket_updates.

The `MicroService URL` field is required.  If `Require an Endpoint?` is set to `Yes` any event endpoints left blank will not trigger.  If it is set to `No` then any event endpoints left blank will be fired to the `MicroService URL`.  This is useful if all events trigger the same URL.

## Installation

The instructions below assume you have access to modify the SirPortly installation:

1. Copy `after_commit.rb` to `{install_dir}/modules/after_commit.rb`.
2. Include the module in `{install_dir}/config/sirportly.rb` by adding `config.plugins.custom = ['after_commit']` to the bottom of your config.
3. Restart SirPortly with `restart sirportly`.
4. Navigate to `Admin` > `Integration Options`.
5. Check the checkbox next to `Aftercommit`.
6. Enter in the MicroService URL field (e.g. `http://api.example.com/`)
7. Select `Yes` or `No` for `Require an endpoint?`
8. Enter the endpoint for each event if required
9. Enter any required `Query String` details (e.g. `auth=user:key`)
10. Click `Save Configuration`
