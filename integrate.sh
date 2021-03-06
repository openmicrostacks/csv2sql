#!/bin/bash -eu

################################################################################
# Testing foundation.
################################################################################
init_psql() {
  docker-compose up -d psql_server
  docker-compose run dockerize -wait tcp://psql_server:5432 -timeout 30s
  sleep 10  # Wait for DB startup.
}

initialize() {
  rm -f .coverage
  docker-compose down
  docker-compose build

}

################################################################################
# Testing.
################################################################################
static_analysis() {
  pylint csv2sql
}

test_units() {
  coverage run -a --source=csv2sql setup.py test
}

test_integration() {
  coverage run -a --source=csv2sql integrate.py
}

################################################################################
# Main.
################################################################################
integrate() {
  initialize
  static_analysis
  test_units

  init_psql
  test_integration
}

integrate
