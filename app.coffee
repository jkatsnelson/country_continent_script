fs = require 'fs'
csv = require 'csv'
_ = require 'underscore'
countries = require __dirname+'/countries'
{"type":"Feature","id":"FRG","properties":{},"c":"SA"}
csv().from.path(__dirname+'/country_to_continent.csv').to.array (data) ->
  data = _.object data
  updatedCountries = _.map countries.features, (country) ->
    iso = country.properties.iso_a2
    country.id = country.properties.iso_a2
    country.c = data[iso]
    if iso is '-99'
      switch country.properties.name
        when 'N. Cyprus' then country.c = 'EU'
        when 'Kosovo' then country.c = 'EU'
        when 'Somaliland' then country.c = 'AF'
    delete country.properties
    country
  updatedCountries = _.filter updatedCountries, (country) ->
    if country.id is 'AQ'
      console.log 'found antarctica'
      return false
    else return true
  fs.writeFile 'updated_countries.js', JSON.stringify(updatedCountries), (err) ->
    if err then throw err
    else console.log 'wee'