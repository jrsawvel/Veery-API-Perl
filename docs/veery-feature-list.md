# Veery Feature List


Veery is a web publishing app.

## Features

* API-based, using REST and JSON.
* API code uses CouchDB and Elasticsearch.
* Server-side clients exist in Perl and Node.js.
* The API and Client apps use different YAML config files. 
* Single-user mode only.
* Logging in only requires an email address. A password is never used.
* The author's profile page is simply a normal post with the title listed in YAML config file.
* Post types: articles and notes. Articles have titles.
* Markup support: Textile, Markdown, Multimarkdown,  and HTML. 
* Additional custom commands exist to control formatting and functionality of a post. 
* Special embed commands for other media types. 
* Simple and enhanced writing areas for blog posts. 
* Simple post forms with few form elements.
* Content headers are also links within the page.
* Content headers can be used to create a table of contents for the page. 
* Streams of posts are displayed only by updated date.
* Author can delete and undelete posts.
* String search.
* Hashtag search.
* RSS feeds for the homepage stream, string search results, and hashtag search results.
* Responsive design.
* Client-side JavaScript is used only with the editor.
* Option to store the markup for each post on the file system by the API code.
* The homepage stream and the individual post pages are stored in memcached by the client code.
* Reading time and word count are calculated for each post.
* Clients use template systems to render pages. Perl client uses HTML::Template, and Node.js client uses Handlebars.


## To-Do

* add `youtube=` embedded media command
* fix the flavored markdown so that my added textile-like commands function like the normal markdown commands or else remove my flavoring
* enable `toc=yes` to work within the client code. the API code supports the command.
* correct how i work with my closing `pq` custom formatting command.
* If possible, add a CouchDB view that generates a list of tag names with their counts. Two display options would be nice: sort list alphabetically by tag name and sort list by tag counts. This would function similar to what the Grebe and Junco apps do. I need the CouchDB equivalent to an SQL query that contains `count(*)` and `group_by`.

