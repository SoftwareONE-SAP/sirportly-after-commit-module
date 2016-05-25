# AfterCommit SirPortly Module

This module was created to trigger an endpoint on our bespoke system which then queries the SirPortly database.  This has been created as a Module as the Macros run prior to the database transaction commit surrounding updates to tickets and ticket_updates.

This module assumes your endpoint requires a GET parameter `auth` with a `user:key` value.

## Installation

The instructions below assume you have access to modify the SirPortly installation:

1. Copy `after_commit.rb` to `{install_dir}/modules/after_commit.rb`.
2. Include the module in `{install_dir}/config/sirportly.rb` by adding `config.plugins.custom = ['after_commit']` to the bottom of your config.
3. Restart SirPortly with `restart sirportly`.
4. Navigate to `Admin` > `Integration Options`.
5. Check the checkbox next to `Aftercommit`.
6. Fill in the URL, Authorisation User and Authorisation Key fields.
7. Click `Save Configuration`
