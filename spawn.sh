#!/bin/bash

bundle exec ruby -e "require './runner'; Workers::Scrapping.perform_async(11)"
