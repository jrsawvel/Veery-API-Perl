
# decided to set the _id to the author name, therefore i may not need the 'name' field, but i'll leave it for now.
 curl -X POST -H "Content-Type: application/json" --data '{ "_id" : "JohnR", "type" : "author", "name" : "JohnR", "email" : "x@x.com", "current_session_id" : "-1" }' http://127.0.0.1:5984/veerydvlp1


# not used
# curl -X POST -H "Content-Type: application/json" --data '{ "type" : "author", "name" : "JR", "email" : "x@x.com", "current_session_id" : "-1" }' http://127.0.0.1:5984/veerydvlp1
