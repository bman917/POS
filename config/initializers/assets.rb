# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( sales_new.js )
Rails.application.config.assets.precompile += %w( item_index_dialog.js )
Rails.application.config.assets.precompile += %w( item_layout.css )
