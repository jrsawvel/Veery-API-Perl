# Veery-flavored Markdown post


Test post with my additions to the Markdown module along with the core functions of Markdown.


## The flavored parts

newlines are automatically
converted into BR tags, but 
this can be disabled with the 'newline_to_br' command set to 'no'.

links are automatically linked: 
http://toledoweather.info but this 
this can be disabled with the 'url_to_link' command set to 'no'.

    ++big text++

    --small text--

    +underlined text+

    -strikethrough text-


++big text++

--small text--

+underlined text+

-strikethrough text-




## Core Markdown

<http://markdowntutorial.com>

<http://daringfireball.net/projects/markdown/basics>

`**bold text**`

`*italicized text*`

`**_bolded and italicized text_**`

`linking : [Visit GitHub!](http://www.github.com)`


br. embedding an image

`![backyard tall coreopsis at late july 2015](http://image.soupmode.com/images/1438351728-image.jpg)`


**bold text**

*italicized text*

**_bolded and italicized text_**

linking : [Visit GitHub!](http://www.github.com)


br. embedding an image

![backyard tall coreopsis at late july 2015](http://image.soupmode.com/images/1438351728-image.jpg)


## Reference-style linking

To get this to work, must use my custom command `url_to_link=no` .

url_to_link=no

Reference-style links allow you to refer to your links by names, which you define elsewhere in your document:

    This is [an example] [id] reference-style link.
    
    [id]: http://example.com/  "Optional Title Here"


This is [an example] [id] reference-style link.

[id]: http://example.com/  "Optional Title Here"


br. Another example ...

    I get 10 times more traffic from [Google] [1] than from [Yahoo] [2] or [MSN] [3].
    
      [1]: http://google.com/        "Google"
      [2]: http://search.yahoo.com/  "Yahoo Search"
      [3]: http://search.msn.com/    "MSN Search"


I get 10 times more traffic from [Google] [1] than from [Yahoo] [2] or [MSN] [3].
    
  [1]: http://google.com/        "Google"
  [2]: http://search.yahoo.com/  "Yahoo Search"
  [3]: http://search.msn.com/    "MSN Search"



br. Different version ...

    I get 10 times more traffic from [Google][] than from [Yahoo][] or [MSN][].
    
      [google]: http://google.com/        "Google"
      [yahoo]:  http://search.yahoo.com/  "Yahoo Search"
      [msn]:    http://search.msn.com/    "MSN Search"


I get 10 times more traffic from [Google][] than from [Yahoo][] or [MSN][].

  [google]: http://google.com/        "Google"
  [yahoo]:  http://search.yahoo.com/  "Yahoo Search"
  [msn]:    http://search.msn.com/    "MSN Search"




## Headers


`### header three`

`#### header four`


### header three

#### header four


## Blockquote

    > This is a blockquote.
    > 
    > This is the second paragraph in the blockquote.
    >
    > ## This is an H2 in a blockquote

> This is a blockquote.
> 
> This is the second paragraph in the blockquote.
>
> ## This is an H2 in a blockquote



br. Nested ...

    > This is the first level of quoting.
    >
    > > This is nested blockquote.
    >
    > Back to the first level.


> This is the first level of quoting.
>
> > This is nested blockquote.
>
> Back to the first level.



br. Another example ...

    > ## This is a header.
    > 
    > 1.   This is the first list item.
    > 2.   This is the second list item.
    > 
    > Here's some example code:
    > 
    >     return shell_exec("echo $input | $markdown_script");



> ## This is a header.
> 
> 1.   This is the first list item.
> 2.   This is the second list item.
> 
> Here's some example code:
> 
>     return shell_exec("echo $input | $markdown_script");










## Lists

Unordered (bulleted) lists use asterisks, pluses, and hyphens (*, +, and -) as list markers. 

    * one
    * two
    * three

* one
* two
* three



br. Ordered (numbered) lists use regular numbers, followed by periods, as list markers:


    1. one
    1. two
    1. three

1. one
1. two
1. three



br. More lists ...

Need to use `newline_to_br=no` to make "pretty" lists within the markup. In these two examples, the HTML output is the same, but the markup is nicer for the first version.


newline_to_br=no

    *   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
        Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
        viverra nec, fringilla in, laoreet vitae, risus.
    *   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.
        Suspendisse id sem consectetuer libero luctus adipiscing.



*   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
    Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
    viverra nec, fringilla in, laoreet vitae, risus.
*   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.
    Suspendisse id sem consectetuer libero luctus adipiscing.



or the lazy, messier markup way ...

    *   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
    Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
    viverra nec, fringilla in, laoreet vitae, risus.
    *   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.
    Suspendisse id sem consectetuer libero luctus adipiscing.




*   Lorem ipsum dolor sit amet, consectetuer adipiscing elit.
Aliquam hendrerit mi posuere lectus. Vestibulum enim wisi,
viverra nec, fringilla in, laoreet vitae, risus.
*   Donec sit amet nisl. Aliquam semper ipsum sit amet velit.
Suspendisse id sem consectetuer libero luctus adipiscing.



br. And even more lists ...

List items may consist of multiple paragraphs. Each subsequent paragraph in a list item must be indented by either 4 spaces or one tab:

    1.  This is a list item with two paragraphs. Lorem ipsum dolor
        sit amet, consectetuer adipiscing elit. Aliquam hendrerit
        mi posuere lectus.
    
        Vestibulum enim wisi, viverra nec, fringilla in, laoreet
        vitae, risus. Donec sit amet nisl. Aliquam semper ipsum
        sit amet velit.
    
    2.  Suspendisse id sem consectetuer libero luctus adipiscing.



1.  This is a list item with two paragraphs. Lorem ipsum dolor
    sit amet, consectetuer adipiscing elit. Aliquam hendrerit
    mi posuere lectus.

    Vestibulum enim wisi, viverra nec, fringilla in, laoreet
    vitae, risus. Donec sit amet nisl. Aliquam semper ipsum
    sit amet velit.

2.  Suspendisse id sem consectetuer libero luctus adipiscing.




br. lists with markdown

    *   A list item with a blockquote:
    
        > This is a blockquote
        > inside a list item.


*   A list item with a blockquote:

    > This is a blockquote
    > inside a list item.


## mixing list types  


    1. Cut the cheese
      * Make sure that the cheese is cut into little triangles.
    
    2. Slice the tomatoes
      * Be careful when holding the knife.
      * For more help on tomato slicing, see Thomas Jefferson's seminal essay _Tom Ate Those_.


1. Cut the cheese
  * Make sure that the cheese is cut into little triangles.

2. Slice the tomatoes
  * Be careful when holding the knife.
  * For more help on tomato slicing, see Thomas Jefferson's seminal essay _Tom Ate Those_.



br. More ...

    1. Crack three eggs over a bowl.
    
     Now, you're going to want to crack the eggs in such a way that you don't make a mess.
    
     If you _do_ make a mess, use a towel to clean it up!
    
    2. Pour a gallon of milk into the bowl.
    
     Basically, take the same guidance as above: don't be messy, but if you are, clean it up!



1. Crack three eggs over a bowl.

 Now, you're going to want to crack the eggs in such a way that you don't make a mess.

 If you _do_ make a mess, use a towel to clean it up!

2. Pour a gallon of milk into the bowl.

 Basically, take the same guidance as above: don't be messy, but if you are, clean it up!






## Escaping chars

it's possible to trigger an ordered list by accident, by writing something like this:

    1986. What a great season.

1986. What a great season.


In other words, a number-period-space sequence at the beginning of a line. To avoid this, you can backslash-escape the period:

    1986\. What a great season.

1986\. What a great season.



br. Same for other syntax ...

To prevent italicizing this phrase:

    \*literal asterisks\*

\*literal asterisks\*


## Horizontal Rule

    ---

---



## My custom formatting commands

These are Textile-like with the period closing the start or end of the command.

horizontal rule `hr.`

hr.

(the hr was stylized with CSS)


br. Forcing a line break `br.`


br. block highlighting that's stylized with CSS using the `q.` and `q..` commands around a block of text.

q.
para one.

para two.

para three.
q..


br. Hashtags are converted to searchable links, but this can be disabled by using `hashtag_to_link=no`


br. the `more.` command controls what text is displayed from the article on the stream homepage. the text prior to `more.` will be the intro text. if the text exceeds X-number of chars, 300 I think, the text gets truncated.


br. surrounding a block of text with `fence.` and `fence..` will display the text with pre and code HTML tags. This will display text as tall or vertical as needed, but the width is limited, I think. If the width is longer, then a horizontal scroll bar is displayed.


I'm not using the `code.` and `code..` commands that I've used in one or two of my other apps. The code./code.. block commands will display text with a fixed height and width. If the text is larger, both horizontal and vertical scroll bars will be used.


br. my new pull quote command uses `pq.` and `pq. .` (no space between the periods).

 pq. this is a test pq. .

pq. this is a test pq..



br. my custom commands and their custom CSS attributes as displayed within this Perl substitution code:

    $formattedcontent =~ s/^q[.][.]/\n<\/blockquote>/igm;
    $formattedcontent =~ s/^q[.]/<blockquote class="highlighted" markdown="1">\n/igm;

    $formattedcontent =~ s/^hr[.]/<hr class="shortgrey" \/>/igm;

    $formattedcontent =~ s/^br[.]/<br \/>/igm;

    $formattedcontent =~ s/^more[.]/<more \/>/igm;

    $formattedcontent =~ s/^fence[.][.]/<\/code><\/pre><\/div>/igm;
    $formattedcontent =~ s/^fence[.]/<div class="fenceClass"><pre><code>/igm;

    $formattedcontent =~ s/pq[.][.]/<\/em><\/big><\/center>/igm;
    $formattedcontent =~ s/^pq[.]/<center><big><em>/igm;



br. Markups supported:

* Textile
* Markdown and MultiMarkdown
* HTML


br. For an article, word count and reading time are calculated. Reading time displayed if the time is at least one minute. Word count is always displayed. 



br. Embedded media

insta=url to instagram page that contains photo to embed.

Example: (obviously no space between the 'i' and 'n'

> i nsta=https://instagram.com/p/5LQ-3NtQj_

insta=https://instagram.com/p/5LQ-3NtQj_

The direct link to the image is displayed and then if desired, the image can be embedded within a post by using this link instead of the insta= command.



br. Embedding a YouTube video.

Copy the embed HTML syntax, offered by YouTube. It doesn't matter if it's the old embed code or the new code that uses the iframe tag.

<iframe width="560" height="315" src="https://www.youtube.com/embed/xwNsG1RPFvA" frameborder="0" allowfullscreen></iframe>


br. Since Veery is a single-user app, I saw no need to restrict the HTML tags that can be used, like I've done with multi-user apps, such as Parula, Junco, and Grebe.

Same for other media such as a Gist at GitHub. Just use the embed code, provided by GitHub.

Embedding this gist <https://gist.github.com/jawinn/e065721580a3bc0f68f9>

<script src="https://gist.github.com/jawinn/e065721580a3bc0f68f9.js"></script>



hr.

fenced text

fence.asdfasdfas asdfa sdfasdfasd fasdfa sasdfasd asdfasdfas asdfa sdfasdfasd fasdfa sasdfasd 

asdfasdfas asdfa sdfasdfasd fasdfa sasdfasd asdfasdfas asdfa sdfasdfasd fasdfa sasdfasd asdfasdfas asdfa sdfasdfasd fasdfa sasdfasd 

asdfasdfas asdfa sdfasdfasd fasdfa sasdfasd 

asdfasdfas asdfa sdfasdfasd fasdfa sasdfasd asdfasdfas asdfa sdfasdfasd fasdfa sasdfasd 
fence..


br. Veery also uses my custom `code.` and `code..` commands.


code.Read a Single Post
==================

Grab my profile page, which has the _id of "profile". 

Currently, the default is to return HTML only.
  curl http://veeryapiperl.soupmode.com/api/posts/profile

This produces the same thing.
  curl http://veeryapiperl.soupmode.com/api/posts/profile/?text=html

{
  "status":200,
  "description":"OK",
  "post": 
    {
      "post_type":"article",
      "title":"Profile",
      "slug":"profile",
      "author":"MrX",
      "created_at":"2015/02/11 14:54:49",
      "updated_at":"2015/04/21 15:56:10",
      "word_count":16,
      "reading_time":0,
      "html":"<a name=\"Profile\"></a>\n<h1 class=\"headingtext\"><a href=\"/profile\">Profile</a></h1>\n\n<p>my profile page that contains nothing because i want to blend into the background.</p>\n\n<p><img src=\"http://farm4.static.flickr.com/3156/2614312687_3fe4cae2a9_o.jpg\" alt=\"\" /></p>\n"
    }
}


Get the markup. The _rev is returned for updating. To include the _rev info, the user's logged-in info must be submitted on the query string with the text=markup.

This will not include the _rev info.
  curl http://veeryapiperl.soupmode.com/api/posts/profile/?text=markup

To include _rev info:
  curl http://veeryapiperl.soupmode.com/api/posts/profile/?text=markup
\&author=MrX\&session_id=50ff8f05c0f5d95aabbe7c5d810340c1


{
  "status":200,
  "description":"OK",
  "post":
    {
      "_rev":"3-97b3bc9434ea346a49b7709c6dd1e9fd",
      "post_type":"article",
      "title":"Profile",
      "slug":"profile",
      "markup":"# Profile\r\n\r\nmy profile page that contains nothing because i want to blend into the background.\r\n\r\n![](http://farm4.static.flickr.com/3156/2614312687_3fe4cae2a9_o.jpg)"
    }
}
code..


