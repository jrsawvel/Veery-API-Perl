# Veery

Simple web publishing app that uses CouchDB, Elasticsearch, and Memcached.


## API

Currently, the API code exists only in Perl. The API code receives and returns JSON.

* API URL: <http://veeryapiperl.soupmode.com/api>
 * example that displays this page: <http://veeryapiperl.soupmode.com/api/posts/info>
 * get the home page stream: <http://veeryapiperl.soupmode.com/api/posts>


## Clients

Two versions of the client code exist. One version was written in Perl, and another version was written in NodeJS.

* <http://veeryclientperl.soupmode.com>
* <http://veeryclientnodejs.soupmode.com>



## RSS

Homepage via Node.js client code:  
<http://veeryclientnodejs.soupmode.com/stream/rss>

Homepage via the Perl client code:  
<http://veeryclientperl.soupmode.com/rss>


Both clients support the same RSS URIs for string and hashtag searches. 

Example RSS output for a hashtag search on 'veery':

* <http://veeryclientnodejs.soupmode.com/tag/veery/rss>
* <http://veeryclientperl.soupmode.com/tag/veery/rss>


## Markup

Formatting can be created by using markup syntax from Markdown, MultiMarkdown, Textile, and HTML.

The Veery Markdown is slightly flavored with some commands that exist in Textile.

Plus, additional custom formatting commands exist that are available, regardless of the markup used.


## Tech Used

* Ubuntu
* Nginx
* FastCGI
* Perl
* HTML::Template
* CouchDB
* Memcached
* Elasticsearch
* NodeJS
* Express
* Handlebars
* Mailgun



