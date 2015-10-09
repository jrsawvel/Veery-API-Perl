# Veery API - Short Version

Veery is a RESTful web publishing app. The API receives and returns JSON.

Test API server:  
<http://veeryapiperl.soupmode.com/api>

Test client sites that use the API:   
 <http://veeryclientperl.soupmode.com>  
 <http://veeryclientnodejs.soupmode.com>

Example: Get a stream of posts:  
<http://veeryapiperl.soupmode.com/api/posts>

Example: Get post titled "Info":  
<http://veeryapiperl.soupmode.com/api/posts/info>

At the moment, the Veery API does not use SSL, and it does not use OAuth.

For GETs that require the user to be logged-in, the URI ends with the query string:  
`/?author_name=[author_name]&session_id=[session_id]`

For POST and PUT requests that require the user to be logged-in, the `author_name` and `session_id` information are included in the JSON that's sent to the API.


---


## USERS

#### Request Login Link  

POST request to:  
`/users/login`  

Sample JSON sent to the API:  
`{ "email" : "x@x.com", "url" : "." }`

`url` field is optional, but it cannot be blank. Normally, the `url` would point to the client action. The URL would be included in the email sent by the API code. 

For the Perl test client site mentioned above, the JSON would include:  
`"url" : "http://veeryclientperl.soupmode.com/nopwdlogin"`

In the returned JSON, the `session_id_rev` is only included when `debug_mode` equals `1` in the API's YAML config file. `session_id_rev` is attached to the URL that's emailed to the author.


#### Activate Login Link

GET request to:  
`/api/users/login/?rev=[rev_id]`



#### Get User Info 

GET request to:  
`/users/[author_name]`  
This request returns minimal info, such as a logged-in flag.

To retrieve more info, such as when attempting to update the email address, the author needs to be logged-in.  
`/users/[author_name]/?author=[author_name]&session_id=[session_id]`



#### Updating Author's Info

PUT request to:  
`/users`

At the moment, only the email address can be updated. To update the author's email address, the client would send JSON similar to this:

    {
        "author": "MrX", 
        "session_id": "5aabbe7c5d810346cb", 
        "id": "2384849494", 
        "rev": "45454554", 
        "new_email" : "new@new.com", 
        "old_email" : "old@old.com"
    }



#### Logging out

GET request to:  
`/users/logout/?author=[author_name]&session_id=[session_id]`


---

## POSTS

#### Get a Single Post

GET request to:  
`/posts/[page_id]`  
`/posts/[page_id]/?text=html`  
`/posts/[page_id]/?text=markup`  
`/posts/[page_id]/?text=full`  

The `_rev` data is required for updating a post. To include the `_rev` data in the returned JSON, the author's logged-in info must be submitted on the query string, along with `text=markup`.

`text=full` causes the returned JSON to include the original markup for the post, along with the formatted HTML.


#### Get the Homepage Stream of Posts

GET request to:  
`/posts`  
`/posts/?page=3`

Note: Veery pulls the content from CouchDB, and it returns articles and notes, sorted by updated date from youngest to oldest.



#### Create a New Post

POST request to: `/posts` 

Example JSON being submitted:

    {
        "author": "MrX", 
        "session_id": "5012344558568686", 
        "submit_type": "Post", 
        "markup": "h1. 13may2015 2059\n\n test post from Perl Veery API"
    }

`submit_type` can be either `Post` or `Preview`.



#### Update a Post

PUT request to: `/posts`

Example JSON being submitted:

    {
        "author": "MrX", 
        "session_id": "50ff8f05c0f5d95aabbe7c5d810323c8", 
        "rev": "1-f6eaf40f56dbb2ccc07919535f891ee1", 
        "post_id": "13may2015-2059", 
        "submit_type": "Update", 
        "markup": "h1. 13may2015 2059\n\n Updated - test post from Perl Veery API"
    }

`submit_type` can be either `Update` or `Preview`.



#### Delete a Post

GET request to:  
`/posts/[page_id]/?action=[delete]&author=[author_name]&session_id=[session_id]`



#### Undelete a Post

GET request to:  
`/posts/[page_id]/?action=[undelete]&author=[author_name]&session_id=[session_id]`



#### Show List of Deleted Posts

GET request to:  
`/posts/?deleted=yes&author=[author_name]&session_id=[session_id]`


---

## SEARCHES

#### String Search

GET request to:  
`/searches/string/[string]`

Examples:  
`/searches/string/beer`   
`/searches/string/craft%20beer`

Note: For string searches, the API code works against Elasticsearch, which returns posts sorted by relevance as determined by Eleasticsearch and not by updated date.



#### Tag search

GET request to:  
`/searches/tag/[tag_name]`

Example search on the hashtag "toledo" :  
`/searches/tag/toledo`


