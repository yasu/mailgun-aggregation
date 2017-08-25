#!/usr/bin/env ruby

require 'mailgun-aggregation'

apikey = 'key-xxx'
domain = 'xxx.com'

client = MailgunAggregation::Client.new(apikey, domain)
client.run
