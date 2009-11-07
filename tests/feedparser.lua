require "feedparser"
--this is by no means comprehensice

local function filecontents(path)
	local f = io.open(path, 'r')
	if not f then return nil, path .. " is not a file or doesn't exist." end
	local res = f:read('*a')
	f:close()
	return res
end 


print("atom")
local res = assert(feedparser.parse(assert(filecontents("tests/feeds/atom1.0-1.xml"))))
assert(#res.entries==2)
assert(res.version=="atom10")
assert(res.feed.author=="John Doe")
assert(res.feed.link=="http://example.org/")

local a = assert(feedparser.parse(assert(filecontents("tests/feeds/atom-ob.xml"))))
assert(a.version=="atom10")
assert(a.format=="atom")
assert(#a.entries==10)
print("rss")
local res = assert(feedparser.parse(assert(filecontents("tests/feeds/rss-reddit.xml"))))
assert(#res.entries==100)
assert(res.feed.title=="reddit.com: what's new online")

print("rss2")
local res = assert(feedparser.parse(assert(filecontents("tests/feeds/rss-userland-dawkins.xml"))))

print("rebasing and url resolution")
local feed = [[<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:base="http://foo.com/">
 <title>Example Feed</title>
 <link href="/excellent"/>
 <updated>2003-12-13T18:30:02Z</updated>
 <author>
   <name>John Doe</name>
 </author>
 <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>

 <entry>
   <title>The Exciting conclusion of Atom-Powered Robots Run Amok</title>
   <link href="/2003/12/13/atom03"/>
   <id>urn:uuid:1225c695-cfb8-4ebb-whatever</id>
   <updated>2003-12-13T18:30:02Z</updated>
   <summary>Some text.</summary>
 </entry>
  <entry xml:base="/cheetos">
   <title>Atom-Powered Robots Run Amok, part One</title>
   <link href="/2003/12/13/atom03"/>
   <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
   <updated>2002-10-01T18:30:00Z</updated>
   <summary>arr, texty</summary>
 </entry>

</feed>]]
local res = assert(feedparser.parse(feed))
assert(res.feed.link=="http://foo.com/excellent")

local feed = [[<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
 <title>Example Feed</title>
 <link href="/excellent"/>
 <updated>2003-12-13T18:30:02Z</updated>
 <author>
   <name>John Doe</name>
 </author>
 <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>

 <entry>
   <title>The Exciting conclusion of Atom-Powered Robots Run Amok</title>
   <link href="/2003/12/13/atom03"/>
   <id>urn:uuid:1225c695-cfb8-4ebb-whatever</id>
   <updated>2003-12-13T18:30:02Z</updated>
   <summary>Some text.</summary>
 </entry>
  <entry xml:base="/cheetos">
   <title>Atom-Powered Robots Run Amok, part One</title>
   <link href="/2003/12/13/atom03"/>
   <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
   <updated>2002-10-01T18:30:00Z</updated>
   <summary>arr, texty</summary>
 </entry>

</feed>]]
local res = assert(feedparser.parse(feed, "http://bacon.net"))
assert(res.feed.link=="http://bacon.net/excellent")
