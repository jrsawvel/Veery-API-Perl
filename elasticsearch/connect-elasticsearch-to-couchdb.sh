curl -X PUT 'http://127.0.0.1:9200/_river/veerydvlp1/_meta' -d '{ "type" : "couchdb", "couchdb" : { "host" : "localhost", "port" : 5984, "db" : "veerydvlp1", "filter" : null }, "index" : { "index" : "veerydvlp1", "type" : "veerydvlp1", "bulk_size" : "100", "bulk_timeout" : "10ms" } }'

