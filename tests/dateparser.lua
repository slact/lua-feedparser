local dateparser = require "feedparser.dateparser"

print("RFC2822")
assert(dateparser.parse('Fri, 09 Jan 2009 07:16:10 GMT')==1231485370)
assert(dateparser.parse('Fri, 09 Jan 2009 07:16:10 EST')==1231503370)

assert(dateparser.parse('09 Feb 2012 07:16:10 +0000')==1328771770)
assert(dateparser.parse('09 Feb 2012 07:16:10 +1201')==1328728510)
assert(dateparser.parse('09 Feb 2012 07:16:10 +0752')==1328743450)
assert(dateparser.parse('01 Jan 1970 00:00:00 +0101')==-3660)
assert(dateparser.parse('09 Feb 2012 07:16:10 +0101')==1328768110)
assert(dateparser.parse('1 Jul 1980 00:00:00 GMT')==331257600)
assert(dateparser.parse('1 Jul 1980 00:00:00 PDT')==331282800)

print("W3CDTF")
assert(dateparser.parse('1970-01-01T00:00:00Z')==0)
assert(dateparser.parse('1970-02-01T00:15:00Z')==2679300)
assert(dateparser.parse('2003-12-31T10:14:55.117Z')==1072865695)
assert(dateparser.parse('1980-01-09')==316224000)
assert(dateparser.parse('1980-03-01')==320716800)
assert(dateparser.parse('2003-12-31T10:14:55-08:00')==1072894495)


print("before unix epoch")
if dateparser.parse('09 Dec 1965 07:45:51 PDT')~=-128164449  
  or dateparser.parse('1966-06-23T1:12Z')~=-111278880 then 
	print("Warning: your OS doesn't do times before unix epoch properly. Not strictly a dateparser test error.\nJust thought you should know.")
end
