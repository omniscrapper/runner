#!/bin/bash
# Enqueues specified task in sidekiq.
# The only argument for this script is an ID of task in OmniScrapperHQ database.
# Example: ./spawn.sh 11
bundle exec ruby -e "require './runner'; Workers::Scrapping.perform_async($1)"
