# Veery Curl Testing

## Read a Single Post

Grab my profile page. Currently, the default is to return HTML only.
    
    curl http://veeryapiperl.soupmode.com/api/posts/profile

This produces the same thing.

    curl http://veeryapiperl.soupmode.com/api/posts/profile/?text=html

Returned JSON:

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


### Retrieve the markup for a post.

The `_rev` is returned for updating. To include the `_rev` info, the user's logged-in info must be submitted on the query string along with `text=markup`.

This will not include the `_rev` info.

    curl http://veeryapiperl.soupmode.com/api/posts/profile/?text=markup

To include `_rev` info:

    curl http://veeryapiperl.soupmode.com/api/posts/profile/?text=markup\&author=MrX\&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

Returned JSON:

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


### Retrieve the markup and the HTML
 
    curl http://veeryapiperl.soupmode.com/api/posts/profile/?text=full

Returned JSON:

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



## Get the Homepage Stream of Posts

    curl http://veeryapiperl.soupmode.com/api/posts

Page 3 of the stream of posts

    curl http://veeryapiperl.soupmode.com/api/posts/?page=3

Returned JSON:

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


## Stream of Posts from a Search Request


### String search

_Currently, a GET request is used. I may change this to a POST request._

A string search is comprised of one or more words.

Search on "beer":

    curl http://veeryapiperl.soupmode.com/api/searches/string/beer

Search on "craft beer":

    curl http://veeryapiperl.soupmode.com/api/searches/string/craft%20beer

**Elasticsearch notes:** It seems that when entering a text string surrounded by double quotes, then an exact string match is conducted by Elasticsearch. When a plus sign separates words, then it seems that  an 'OR' Boolean search is conducted.


### Tag search

Search on the hashtag "toledo":

    curl http://veeryapiperl.soupmode.com/api/searches/tag/toledo

Returned JSON for a hashtag search on "beer" 

    {
      "status":200,
      "description":"OK",
      "next_link_bool":0,
      "posts":[
        {
          "author":"MrX",
          "reading_time":1,
          "text_intro":" <span class=\"streamtitle\"><a href=\"/black-cloister-feb-26-2015-notes\">Black Cloister Feb 26 2015 notes</a></span> -   Feb 26, 2015 - Toledo Blade - Black Cloister Brewing Co. taps opening date  The story is part of a new Blade column, called \"Raise a Glass.\"  ",
          "slug":"black-cloister-feb-26-2015-notes",
          "formatted_updated_at":"Feb 26, 2015 16:14:32 Z",
          "post_type":"article",
          "more_text_exists":1,
          "tags":["toledo","beer","brewery"],
          "updated_at":"2015/02/26 16:14:32"
        },
        {
          "author":"MrX",
          "reading_time":1,
          "text_intro":"<span class=\"streamtitle\"><a href=\"/jan-15-2015-insights-from-tom-at-titgemeiers\">Jan 15, 2015 insights from Tom at Titgemeier's.</a></span> -   I visited Titgemeier's this morning to buy bird seed, honey, and a bottle capper. I broke our capper last night.  I chatted with Tom for a while. We definitely missed a good Glass City Mashers meeting last Thursday. Chris spoke. He's the owne ...",
          "slug":"jan-15-2015-insights-from-tom-at-titgemeiers",
          "formatted_updated_at":"Feb 25, 2015 13:27:01 Z",
          "post_type":"article",
          "more_text_exists":1,
          "tags":["beer","business","toledo"],
          "updated_at":"2015/02/25 13:27:01"
        }
      ]    
    }


 To-do : Maybe add the "TAGS" API command.  
`curl http://veeryapiperl.soupmode.com/api/tags/beer`

 To-do : Add advanced search options, such as Boolean searches by exploiting Elasticsearch's more sophisticated features.


### String search on a hashtag

    curl http://veeryapiperl.soupmode.com/api/searches/string/%23scarf




## Login

### Create and send the no-password login link


    curl -X POST -H "Content-Type: application/json" --data '{ "email" : "x@x.com", "url" : "http://veeryclientperl/nopwdlogin"}' http://veeryapiperl.soupmode.com/api/users/login

Returned JSON if successful: 

    {    
      "status":200,
      "session_id_rev":"1-073335f570d5cf202bac424e0b05cb9b",
      "system_message":"A new login link has been created and sent.",
      "user_message":"Creating New Login Link",
      "description":"OK"
    }

The `session_id_rev` name=value is only included in the returned JSON when `debug_mode` equals `1` in the API's YAML config file.


### Activating the no-password login link

This will create the user's login session.

    curl http://veeryapiperl.soupmode.com/api/users/login/?rev=12345

Returned JSON:

    {
      "author_name":"MrX",
      "session_id":"50ff8f05c0f5d95aabbe7c5d810323c8",
      "status":200,
      "description":"OK"
    }



## Get Author's Info

At the moment, the submitted author name is case-sensitive with regards to the lookup within CouchDB.

The function is useful to determine if the author is logged-in.

    curl http://veeryapiperl.soupmode.com/api/users/MrX

Returned JSON:

    {
      "is_logged_in":0,
      "status":200,
      "name":"MrX",
      "type":"author",
      "description":"OK"
    }


If valid login, then additional info is returned:

    curl http://veeryapiperl.soupmode.com/api/users/MrX/?author=MrX\&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

Returned JSON:

    {
      "_id"  : "abbe7c5d810006f8",
      "_rev" : "12-90b9a5ae6c32d",
      "type" : "author",
      "name" : "MrX",
      "is_logged_in":1,
      "email" : "mrx@mrx.xyz",
      "current_session_id" : "5aabbe7c5d8103411c"
    }


## Update Author's Info


At the moment, only the email address can be updated because little else is stored within the author's doc that can be modified.

    curl -X PUT -H "Content-Type: application/json" --data '{"author": "MrX", "session_id": "5aabbe7c5d810346cb", "id": "2384849494", "rev": "45454554", "new_email" : "new@new.com", "old_email" : "old@old.com"}' http://veeryapiperl.soupmode.com/api/users

Returned JSON:

    {
      "status":200,
      "description":"OK"
    }




## Create a New Post

    curl -X POST -H "Content-Type: application/json" --data '{"author": "MrX", "session_id": "5012344558568686", "submit_type": "Post", "markup": "h1. 13may2015 2059\n\n test post from Perl Veery API"}' http://veeryapiperl.soupmode.com/api/posts


Returned JSON

    {
      "html":"<a name=\"13may2015_2059\"></a>\n<h1 class=\"headingtext\"><a href=\"/13may2015-2059\">13may2015 2059</a></h1>\n\n<p> test post from Perl Veery <span class=\"caps\">API</span></p>",
      "status":200,
      "rev":"1-f6eaf40f56dbb2ccc07919535f891ee1",
      "post_id":"13may2015-2059",
      "description":"OK"
    }




## Update a Post

### Preview 

    curl -X PUT -H "Content-Type: application/json" --data '{"author": "MrX", "session_id": "50ff8f05c0f5d95aabbe7c5d810323c8", "rev": "50ff8f05c0f5d95aabbe7c5d810323c8", "post_id": "13may2015-2059", "submit_type": "Preview", "markup": "h1. 13may2015 2059\n\n Updated - test post from Perl Veery API"}' http://veeryapiperl.soupmode.com/api/posts


Returned JSON:

    {
      "html":"<a name=\"13may2015_2059\"></a>\n<h1 class=\"headingtext\"><a href=\"/\">13may2015 2059</a></h1>\n\n<p> Updated - test post from Perl Veery <span class=\"caps\">API</span></p>",
      "status":200,
      "description":"OK"
    }


### Wrong rev info submitted on update

    {
      "status":"400",
      "system_message":"Invalid rev information provided.",
      "user_message":"Unable to update post.",
      "description":"Bad Request"
    }


### Not logged in when trying to create or update content

    {
      "status":"400",
      "system_message":"You are not logged in.",
      "user_message":"Unable to peform action.",
      "description":"Bad Request"
    }


### Successfully updating a post

    curl -X PUT -H "Content-Type: application/json" --data '{"author": "MrX", "session_id": "50ff8f05c0f5d95aabbe7c5d810323c8", "rev": "1-f6eaf40f56dbb2ccc07919535f891ee1", "post_id": "13may2015-2059", "submit_type": "Update", "markup": "h1. 13may2015 2059\n\n Updated - test post from Perl Veery API"}' http://veeryapiperl.soupmode.com/api/posts

Returned JSON:

    {
      "html":"<a name=\"13may2015_2059\"></a>\n<h1 class=\"headingtext\"><a href=\"/13may2015-2059\">13may2015 2059</a></h1>\n\n<p> Updated - test post from Perl Veery <span class=\"caps\">API</span></p>",
      "title": "13may2015 2059",
      "status":200,
      "rev":"2-43eb2b79a7d58de0e3678387cfd1e5c9",
      "description":"OK"
    }





## Deleting and Undeleting a Post

Change the value for `action` accordingly.

    curl http://veeryapiperl.soupmode.com/api/posts/13may2015-2059/?action=undelete\&author=MrX\&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

Returned JSON

    {
      "status":200,
      "description":"OK"
    }



## Show List of Deleted Posts

Author must be logged in.

    curl http://veeryapiperl.soupmode.com/api/posts/?deleted=yes\&author=Mrx\&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

Returned JSON:

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
          "title": "%20Test%20post%202Mar2015%0A%0Acreated%20within%20the%20javascript%20editor.%0A"
        },
      ],
      "description":"OK"
    }



## Logging Out

    curl http://veeryapiperl.soupmode.com/api/users/logout/?author=MrX\&session_id=50ff8f05c0f5d95aabbe7c5d810340c1

Returned JSON:

    {
      "status":200,
      "description":"OK",
      "logged_out":"true"
    }

If unsuccessful for some reason:

    {
      "status":"400",
      "description":"Bad Request",
      "user_message":"Unable to logout.",
      "system_message":"Invalid info submitted."
    }



