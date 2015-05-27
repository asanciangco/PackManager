#!/bin/bash
# Nickolas Westman, CS130
# Basic commands to grab json dumps

# Historical Weather API
curl --header "Token: FgFYQJXIFJwfhPAWbARqFNwPqdokgUeC" "http://www.ncdc.noaa.gov/cdo-web/api/v2/data?datasetid=GHCND&locationid=ZIP:90012&startdate=2013-05-28&enddate=2013-06-03&sortfield=date&limit=1000"