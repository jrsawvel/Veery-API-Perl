# Veery API

Veery is a basic web publishing app. 

This doc describes Veery's API, which uses a RESTful interface to receive and return JSON.

The API code uses CouchDB and Elasticsearch, although I'm not exploiting the full capabilities of both servers. 

## To-Do

* Create a CouchDB view that produces a list of hashtag names, used across all posts, along with the number of times each hashtag was used.
* Use advance features of Elasticsearch to allow client callers to make more sophisticated search requests.

The Veery API code does not store web pages in a caching server. This responsibility belongs to the client code. In my Perl and NodeJS client code examples, I store web pages in memcached. 

The Veery API is used at the following test site:  
`http://veeryapiperl.soupmode.com`

Accessing the above link returns an error because each function described below (users, posts, searches) is preceded with '/api' in the URL, such as '/api/posts' which returns the JSON for the homepage stream of posts. 

Here's a working example:  
<http://veeryapiperl.soupmode.com/api/posts>

Example of retrieving the JSON for the post titled "Info."  
<http://veeryapiperl.soupmode.com/api/posts/info>

Two test client sites access the API.

* <http://veeryclientperl.soupmode.com>
* <http://veeryclientnodejs.soupmode.com>

I'm not using SSL, nor am I using OAuth.

For GETs that require the user to be logged-in, the URI ends with the query string:  
`/?author_name=[author_name]&session_id=[session_id]`

For POST and PUT requests that require the user to be logged-in, the `author_name` and `session_id` information are included in the JSON that's sent to the API.

If the API function requires the client to be logged-in, and if the client is not logged-in, then the following JSON is returned:

    {
        "status": "400",
        "description": "Bad Request",
        "user_message": "Unable to peform action.",
        "system_message": "You are not logged in."
    }



## USERS

Veery is a single-user app. It's a bit odd that this function is plural, but I'm following standard practices by using plural nouns.

No user account creation process exists. When configuring a Veery install, a shell script is executed that uses Curl to create the author doc in CouchDB. The author's email address is included in the script.

Veery uses a no-password login procedure. To login, the author only needs to provide the email address that matches the entry, contained in CouchDB. 

If the email addresses match, then the Veery API emails the author a link that will activate the author's login session.

The Veery API provides a way to update the author's email address in CouchDB.


### Request Login Link

Uses a POST request to `/users/login`

Example JSON that the client sends to the API:
 
    { 
        "email" : "x@x.com", 
        "url" : "http://clientapp/nopwdlogin"
    }

`url` field is optional, but it cannot be blank. If you have a client app that will receive the user's input, then enter the client code URL here. Otherwise, enter a forward slash or any character or string.

Working example that supports the Perl version of the Veery client:  

    { 
        "email" : "x@x.com", 
        "url" : "http://veeryclientperl.soupmode.com/nopwdlogin"
    }

For the above example, the API code would email `x@x.com` a link that would look like this:  
<http://veeryclientperl.soupmode.com/nopwdlogin/1-613542e9a3dcc10b973fc7f4bfb8xyz>

If sending this JSON to the API code:  

    { 
        "email" : "x@x.com", 
        "url" : "."
    }

Then the email will contain:  
`./1-613542e9a3dcc10b973fc7f4bfb8xyz`

If the request to the API is successful, then the API code uses the Mailgun API to send the email, and then the API returns the following JSON to the client caller:

    {    
        "status":200,
        "session_id_rev":"1-073335f570d5cf202bac424e0b05cb9b",
        "system_message":"A new login link has been created and sent.",
        "user_message":"Creating New Login Link",
        "description":"OK"
    }

The `session_id_rev` is only included in the returned JSON when `debug_mode` equals `1` in the API's YAML config file.


### Activate Login Link

Uses a GET request to `/api/users/login/?rev=[rev_id]`

This activation process can occur only one time. A flag is set in the CouchDB doc that prevents the login link from being used again.

`[rev_id]` is the alpha-numeric string attached to the end of the login link emailed above. From the above example, it would be `1-613542e9a3dcc10b973fc7f4bfb8xyz`

If the request to login is successful, then the API returns the following JSON:

    {
        "author_name":"MrX",
        "session_id":"50ff8f05c0f5d95aabbe7c5d810323c8",
        "status":200,
        "description":"OK"
    }



### Get User Info 

This uses a GET request to `/users/[author_name]`

At the moment, the author name is case-sensitive with regards to the lookup within CouchDB. If the author's name is stored as `MrX` then submitting `mrx` will result in a failed lookup.

This request can be used to determine if the author is logged-in. And if the author is logged-in, then the author's additional information is returned in the JSON.

Example GET request to `/users/MrX` returns:

    {
        "is_logged_in":0,
        "name":"MrX",
        "type":"author",
        "status":200,
        "description":"OK"
    }


This example GET request uses:   

    /users/MrX/?author=MrX&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

and returns the following JSON, provided that the author and session information confirm that the author is logged in:

    {
        "_id"  : "abbe7c5d810006f8",
        "_rev" : "12-90b9a5ae6c32d",
        "type" : "author",
        "name" : "MrX",
        "email" : "mrx@mrx.xyz",
        "current_session_id" : "5aabbe7c5d8103411c"
    }


### Updating Author's Info

This uses a PUT request to `/users`

At the moment, only the email address can be updated because Veery stores little information about the author in CouchDB that can be modified. 

To update the author's email address, the client would send JSON similar to this:

    {
        "author": "MrX", 
        "session_id": "5aabbe7c5d810346cb", 
        "id": "2384849494", 
        "rev": "45454554", 
        "new_email" : "new@new.com", 
        "old_email" : "old@old.com"
    }

If the request is successful, then the API returns:

    {
        "status":200,
        "description":"OK"
    }




### Logging out

This uses a GET request to: 

    /users/logout/?author=[author_name]&session_id=[session_id]



Example:
    
    /users/logout/?author=MrX&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

If successful, the API returns the following JSON:

    {
        "status":200,
        "description":"OK",
        "logged_out":"true"
    }


If unsuccessful for some reason, then the returned JSON includes:

    {
        "status":"400",
        "description":"Bad Request",
        "user_message":"Unable to logout.",
        "system_message":"Invalid info submitted."
    }





## POSTS

### Get a Single Post

This uses a GET request to `/posts/[page_id]`

Example: `/posts/profile` which grabs my profile page.

Currently, the default is to return HTML markup only.

This request produces the same thing as the above default request.  
`/posts/profile/?text=html`

If the article exists, then the API returns the following JSON for the above request:

    {
        "status":200,
        "description":"OK",
        "post": 
            {
                "author":"MrX",
                "reading_time":0,
                "created_at":"2015/02/11 14:54:49",
                "updated_at":"2015/04/21 15:56:10",
                "slug":"profile",
                "post_type":"article",
                "title":"Profile",
                "word_count":16,
                "html":"<a name=\"Profile\"></a>\n<h1 class=\"headingtext\"><a href=\"/profile\">Profile</a></h1>\n\n<p>my profile page that contains nothing because i want to blend into the background.</p>\n\n<p><img src=\"http://farm4.static.flickr.com/3156/2614312687_3fe4cae2a9_o.jpg\" alt=\"\" /></p>\n"
            }
    }


### Get Markup and _rev Data

Uses a GET request.

The `_rev` data is required for updating a post. To include the `_rev` data, the user's logged-in info must be submitted on the query string, along with the `text=markup` .

The result of this request will not include `_rev` data for a post because the author's logged-in information was not included in the request.  
`/posts/profile/?text=markup`

The returned JSON for the following request will include `_rev` data, provided the author is confirmed to be logged-in.
  
    /posts/profile/?text=markup&author=MrX&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

If the author is logged-in, then the returned JSON includes:

    {
        "status":200,
        "description":"OK",
        "post":
            {
                "_rev":"3-97b3bc9434ea346a49b7709c6dd1e9fd",
                "title":"Profile",
                "slug":"profile",
                "post_type":"article",
                "markup":"# Profile\r\n\r\nmy profile page that contains nothing because i want to blend into the background.\r\n\r\n![](http://farm4.static.flickr.com/3156/2614312687_3fe4cae2a9_o.jpg)"
            }
    }


### Get Markup and HTML

This uses a GET request to `/posts/[page_id]/?text=full`

Example: `/posts/profile/?text=full`  returns both the markup and HTML text for the profile page.

    {
        "status":200,
        "description":"OK",
        "post":
            {
                "author":"MrX",
                "title":"Profile",
                "slug":"profile",
                "post_type":"article",
                "word_count":16,
                "reading_time":0,
                "created_at":"2015/02/11 14:54:49",
                "updated_at":"2015/04/21 15:56:10",
                "markup":"# Profile\r\n\r\nmy profile page that contains nothing because i want to blend into the background.\r\n\r\n![](http://farm4.static.flickr.com/3156/2614312687_3fe4cae2a9_o.jpg)",
                "html":"<a name=\"Profile\"></a>\n<h1 class=\"headingtext\"><a href=\"/profile\">Profile</a></h1>\n\n<p>my profile page that contains nothing because i want to blend into the background.</p>\n\n<p><img src=\"http://farm4.static.flickr.com/3156/2614312687_3fe4cae2a9_o.jpg\" alt=\"\" /></p>\n"
            }
    }



### Get the Homepage Stream of Posts

This uses a GET request to `/posts`

For the POSTS function, Veery returns articles and notes by updated date, sorted  from youngest to oldest. The POSTS API works against CouchDB. 

> Note: For string and tag searches, the SEARCHES API code works against Elasticsearch, and the stream of posts is returned by relevance as determined by Eleasticsearch and not by updated date.

For the `/posts` requests, the default is to retrieve the first page of posts.

To retrieve another page, the request would be `/posts/?page=3`

Here is the returned JSON for a sample stream that contains two posts:

    {
        "status":200,
        "description":"OK",
        "posts":
            [
                {
                    "author":"MrX",
                    "reading_time":0,
                    "more_text_exists":1,
                    "tags":[],
                    "text_intro":" <span class=\"streamtitle\"><a href=\"/test-multimarkdown\">test multimarkdown</a></span> -   Here is as example of [table][simple_table] followed by a more complex example from the documentation   simple_table       \tFirst Header \tSecond Header \tThird Header \t      \tFirst row \tData \tVery long data entry \t    \tSecond row \tCell \tCell \t       Prototype table       ...",
                    "updated_at":"2015/04/30 01:57:55",
                    "formatted_updated_at":"Apr 30, 2015 01:57:55 Z",
                    "slug":"test-multimarkdown",
                    "post_type":"article"
                },
                {
                    "author":"MrX",
                    "reading_time":0,
                    "more_text_exists":0,
                    "tags":["scaup","blogging"],
                    "text_intro":"<span class=\"streamtitle\"><a href=\"/info\">Info</a></span> -   Minimal web publishing tool.  Formatting can be created by using markup syntax from Markdown, MultiMarkdown, Textile, and HTML.  Tech used:   Ubuntu Nginx FastCGI Perl HTML::Template CouchDB Memcached Elasticsearch  <a href=\"/tag/scaup\">#scaup</a> <a href=\"/tag/blogging\">#blogging</a>",
                    "updated_at":"2015/04/29 21:56:57",
                    "formatted_updated_at":"Apr 29, 2015 21:56:57 Z",
                    "slug":"info",
                    "post_type":"article"
                }
            ]
    }



### Create a New Post

Uses a POST request to `/posts` with the following JSON being submitted as an example:

    {
        "author": "MrX", 
        "session_id": "5012344558568686", 
        "submit_type": "Post", 
        "markup": "h1. 13may2015 2059\n\n test post from Perl Veery API"
    }

`submit_type` can be either `Post` or `Preview`.

If the `"submit_type":"Post"` request was successful, then JSON similar to this will be returned:

    {
        "status":200,
        "description":"OK",
        "post_id":"13may2015-2059",
        "rev":"1-f6eaf40f56dbb2ccc07919535f891ee1",
        "html":"<a name=\"13may2015_2059\"></a>\n<h1 class=\"headingtext\"><a href=\"/13may2015-2059\">13may2015 2059</a></h1>\n\n<p> test post from Perl Veery <span class=\"caps\">API</span></p>"
    }

If the post was a `"submit_type":"Preview"`, then only the `html` is returned in the JSON, along with `status` and `description`.



### Update a Post

Uses a PUT request to `/posts`.

This is a preview request, which means CouchDB is not updated for the post. The markup is formatted to HTML and returned to the client for previewing.

    {
        "author": "MrX", 
        "session_id": "50ff8f05c0f5d95aabbe7c5d810323c8", 
        "rev": "50ff8f05c0f5d95aabbe7c5d810323c8", 
        "post_id": "13may2015-2059", 
        "submit_type": "Preview", 
        "markup": "h1. 13may2015 2059\n\n Updated - test post from Perl Veery API"
    }


The returned JSON for a preview request:

    {
        "html":"<a name=\"13may2015_2059\"></a>\n<h1 class=\"headingtext\"><a href=\"/\">13may2015 2059</a></h1>\n\n<p> Updated - test post from Perl Veery <span class=\"caps\">API</span></p>",
        "status":200,
        "description":"OK"
    }


When attempting to update a post by submitting invalid `_rev` info, the returned JSON is:

    {
        "status":"400",
        "description":"Bad Request",
        "user_message":"Unable to update post.",
        "system_message":"Invalid rev information provided."
    }


When attempting to create or update a post without being logged-in, the returned JSON is:

    {
        "status":"400",
        "description":"Bad Request",
        "user_message":"Unable to peform action.",
        "system_message":"You are not logged in."
    }



This is a successful PUT request that updates a post. This is an example of JSON sent by the client:

    {
        "author": "MrX", 
        "session_id": "50ff8f05c0f5d95aabbe7c5d810323c8", 
        "rev": "1-f6eaf40f56dbb2ccc07919535f891ee1", 
        "post_id": "13may2015-2059", 
        "submit_type": "Update", 
        "markup": "h1. 13may2015 2059\n\n Updated - test post from Perl Veery API"
    }

And the returned JSON from a successful update:

    {
        "html":"<a name=\"13may2015_2059\"></a>\n<h1 class=\"headingtext\"><a href=\"/13may2015-2059\">13may2015 2059</a></h1>\n\n<p> Updated - test post from Perl Veery <span class=\"caps\">API</span></p>",
        "title": "13may2015 2059",
        "status":200,
        "rev":"2-43eb2b79a7d58de0e3678387cfd1e5c9",
        "description":"OK"
    }



### Deleting and Undeleting a Post

Uses a GET request to:

    /posts/[page_id]/?action=[delete|undelete]&author=[author_name]&session_id=[session_id]

Example of deleting a post:

    /posts/13may2015-2059/ action=delete&author=MrX&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

Example of undeleting a post:

    /posts/13may2015-2059/ action=undelete&author=MrX&session_id=50ff8f05c0f5d95aabbe7c5d810340c1


The returned JSON for a successful operation:

    {
        "status":200,
        "description":"OK"
    }



### Show List of Deleted Posts

Uses a GET request to:

    /posts/?deleted=yes&author=[author_name]&session_id=[session_id]

Example:
  
    /posts/?deleted=yes&author=Mrx&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

The returned JSON example:

    {
        "status":200,
        "posts":[
            {
                "post_type":"note",
                "slug":"test-post-mar-6-2015-0901",
                "title":"test post mar 6, 2015 - 0901"
            },
            {
                "post_type":"article",
                "slug":"test-post-2mar2015",
                title": "%20Test%20post%202Mar2015%0A%0Acreated%20within%20the%20javascript%20editor.%0A"
            },
        ],
        "description":"OK"
    }



## SEARCHES


### String Search

For a string search, a GET request is submitted to `/searches/string/[string]`

If the search is successful, a stream of posts will be returned in JSON.

Example search on the word "beer" :  
`/searches/string/beer`

Example search on the string "craft beer" :  
`/searches/string/craft%20beer`

Elasticsearch notes: It seems that when entering a text string surrounded by double quotes, then an exact string match is conducted by Elasticsearch. When a plus sign separates words, then it seems that an 'OR' Boolean search is conducted.


### Tag search

For a tag search, a GET request is submitted to `/searches/tag/[tag_name]`

Example search on the hashtag "toledo" :  
`/searches/tag/toledo`


### Search Notes

Currently, searches are done with GET requests. I'm wondering if I should add or change this to POST requests to allow more advance searches.

My Grebe web publishing app offers AND and OR Boolean options with tag searches and with string searches, provided single words are used. This does not exist yet with Veery.



