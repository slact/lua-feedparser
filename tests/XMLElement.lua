local XMLElement = require "feedparser.XMLElement"
require "lxp.lom"

local function req(a, b)
	local t = type(a)
	if t~=type(b) then return false end
	if t == 'table' then
		for i,v in pairs(a) do
			local eq = req(v, b[i])
			if not eq then return nil end
		end
		return true
	elseif t == 'function' or t == 'userdata' then
		return true
	else
		return a == b
	end
end

local function dump(tbl)
	local function tcopy(t) local nt={}; for i,v in pairs(t) do nt[i]=v end; return nt end
	local function printy(thing, prefix, tablestack)
		local t = type(thing)
		if     t == "nil" then return "nil"
		elseif t == "string" then return string.format('%q', thing)
		elseif t == "number" then return tostring(thing)
		elseif t == "table" then
			if tablestack[thing] then return string.format("%s (recursion)", tostring(thing)) end
			local kids, pre, substack = {}, "\t" .. prefix, (tablestack and tcopy(tablestack) or {})
			substack[thing]=true
			for k, v in pairs(thing) do
				table.insert(kids, string.format('%s%s=%s,',pre,printy(k, ''),printy(v, pre, substack)))
			end
			return string.format("%s{\n%s\n%s}", tostring(thing), table.concat(kids, "\n"), prefix)
		else
			return tostring(thing)
		end
	end
	local ret = printy(tbl, "", {})
	print(ret)
	return ret
end 

local function filecontents(path)
	local f = io.open(path, 'r')
	if not f then return nil, path .. " is not a file or doesn't exist." end
	local res = f:read('*a')
	f:close()
	return res
end 

print "consistency"
local xml = assert(filecontents("tests/xml/simple.xml"))
local l= assert(lxp.lom.parse(xml))
local root = assert(XMLElement.new(l))
assert(req(root, XMLElement.new(lxp.lom.parse(root:getXML()))))

local feedxml = assert(filecontents("tests/xml/simple.xml"))
local feedroot = XMLElement.new(assert(lxp.lom.parse(xml)))
assert(req(feedroot, XMLElement.new(lxp.lom.parse(feedroot:getXML()))))

print "children"
local kids = root:getChildren('foo')
assert(#kids==3)
assert(#root:getChildren({'selfclosing', 'bacon:strip'}==4))
for i, el in ipairs(kids) do
	assert(getmetatable(root)==getmetatable(el))
	assert(el:getTag()=='foo')
end

assert(#root:getChild('foo'):getChildren()==2)
assert(root:getText())

print('blank element')
local blanky = XMLElement.new()
assert(blanky:getText()=='')

print("descendants")
assert(#root:getDescendants()==8)
