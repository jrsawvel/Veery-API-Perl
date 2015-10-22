# Veery NoSQL Doc Types

Three "doc" types exist. If Veery used SQL, these would be three separate tables.

Author

`curl http://127.0.0.1:5984/dbname/MrX`

    {
        "_id" : "MrX",
        "_rev" : "1-435be1729c60657a333adee6e190869d",
        "type" : "author",
        "name" : "MrX",
        "email" : "mrx@mrx.com",
        "current_session_id" : "50ff8f05c0f5d95aabbe7c5d81026436"
    }




Session ID Description

`curl http://127.0.0.1:5984/dbname/50ff8f05c0f5d95aabbe7c5d81026c1a`

    {
        "_id" : "50ff8f05c0f5d95aabbe7c5d81026c1a",
        "_rev" : "2-91027f061be5f73ccb9784d1fff8210e",
        "type" : "session_id",
        "created_at" : "2015/04/17 18:53:03",
        "updated_at" : "2015/04/17 18:53:03",
        "status" : "active"
    }


Post (Article or Note) Description

`curl http://127.0.0.1:5984/dbname/test-post`

    {
        "_id" : "test-post",
        "_rev" : "4-ad0c0316a32ac4b217431127130fd516",
        "author" : "MrX",
        "reading_time" : 2,
        "text_intro" : "paragraph of text",
        "created_at" : "2015/04/17 13:37:35",
        "html" : "entire post formatted in HTML",
        "post_type" : "article",
        "markup" : "entire markup of the post",
        "more_text_exists" : 1,
        "tags" : ["scaup","blogging","couchdb"],
        "post_status" : "public",
        "updated_at" : "2015/04/17 14:09:30",
        "word_count" : 432,
        "type" : "post",
        "title" : "Test post"
    }
