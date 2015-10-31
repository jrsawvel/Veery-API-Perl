# Veery User Guide

_This page is unfinished._


## Homepage

The default homepage view is to list all posts (articles and notes) by updated date. 

If the `more.` command is used in the post, then only the text information that appears before the command will be displayed on the homepage stream view.

If the post text or the text prior to the `more.` command is greater than 300 characters, then the text displayed on the homepage stream is truncated and a "more" link is displayed. This keeps the homepage stream tidy.

The number of posts to display on the homepage stream is determined by a setting in the API's config file. 

At the bottom of the stream page are links for "Older" and "Newer" posts.

Each post contains a permalink, and if hashtags exists, those are also listed.


### Logged-in Author

If the author is logged in, then a small textarea box appears at the top of the homepage stream to allow for quick posts of notes and links.

Underneath the small textarea box are links to use either a larger textarea box or the JavaScript editor.

At the bottom of the homepage stream are links for logging out, viewing the list of deleted posts, and to update the author's information, which at the moment only the email address can be modified.



## Author's Profile Page

The profile page is simply an article or a note that's created by using Veery. The URI or the slug for the profile page is listed as a parameter in the client code's config file. 

The client code will reference this information at the appropriate times, such as when displaying the author's name on a post page. The client code and the template system will link the author's name to the profile page, specified in the config file.



## Logging In

Veery is a single-user app. No account creation process exists. The author's information gets added to the database during the installation and configuration of the app.

Go to `/login` and enter the email address that was used in the shell script to create an entry in CouchDB for the author.

If the email address entered matches the record in the database, then Veery uses the Mailgun service to send an email that contains the login activation link.

The login link can be used only one time. The link contains session information related to the login.



## Creating and Updating a Post

If no title exists for the post, it's considered a "note", and the default markup used is Textile. To override this, then use the command `markdown=yes` within the post.

If the post has a title, then it's an "article." The title appears on the first line of the post. If the title is greater than 75 characters, then the title will get truncated. 

The post ID is the slug, and the slug is determined by the title for an article and the first 75 characters in a note.

For an article, the markup used is determined by how the title was created: the pound sign for Markdown or the `h1.` command for Textile. 

No need to tell the app which markup is being used because the first line of the post will do this.

Example of an article that will use Textile:

> `h1. Recap of the 2014-2015 Winter`

Using Markdown:

> `# Halloween 2015 Forecast`



### Markup

Veery supports Markdown, MultiMarkdown, Textile, and HTML.

This version of Markdown is flavored with some Textile commands, such as strikethrough, small font size, big font size, and underline.

Also, the Veery Markdown by default converts newline chars to the HTML 'BR' tag so that the invisible double space chars are not required at the end of a line to cause a line break. But this function can be disabled by using the command `newline_to_br=no`.

And raw URLs are automatically converted to clickable links. And this can be disabled by using the command `url_to_link=no`.



## Power Commands

 toc=yes|no    - (table of contents for the article)
 
 url_to_link=yes|no
 
 hashtag_to_link=yes|no
 
 markdown=yes|no - (needed because the default markup for a note is textile. this overrides it)
 
 newline_to_br=yes|no



## Custom Formatting Commands

* q. and q..
* br.
* hr.
* more.
* fence. and fence..
* code. and code..
* pq. and pq. . (minus the space between the periods)



## Embedded Media

Commands:

* insta=
* need to add youtube= which exists in my other apps




## Memcached

Each post and page one of the homepage stream are stored in Memcached. The client code is responsible for caching the pages.

At the moment, flushing the cache is only done with a command line shell script. 

**To-do:** Add a client function to flush the cache and to delete individual pages from the cache.


## Deleting and Undeleting Posts

While viewing the page for a note or an article, the author can delete it.

The author can view a list of deleted pages. On this page, the author can choose to undelete a post.



## Search

String search that relies on Elasticsearch. The full capability of Elasticsearch, however, is not yet being exploited.

Hashtags are automatically formatted as links when clicked, produces a hashtag search against CouchDB.


## RSS

RSS feeds exist for the homepage stream, string search results, and hashtag search results.

