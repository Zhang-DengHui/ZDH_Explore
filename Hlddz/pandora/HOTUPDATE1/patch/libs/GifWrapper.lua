GifWrapper = {}
local GifWrapper = GifWrapper

local CCFileUtils = CCFileUtils
local InstantGif = InstantGif
local CacheGif = CacheGif
local parsedGifs = {}

local function isGifValid()
	return InstantGif ~= nil
end

function GifWrapper.create(t) 
	return GifWrapper.new(t).sprite
end

function GifWrapper.new(t)
	local obj = {}
	setmetatable(obj, { __index = GifWrapper })
	obj:ctor(t)
	return obj
end

function GifWrapper:ctor(t)
	local path = t.path
	if not isGifValid() then 
		return 
	end
	if not parsedGifs[path] then
		self.sprite = InstantGif:create(CCFileUtils:sharedFileUtils():fullPathForFilename(path))
		parsedGifs[path] = true
	else
		self.sprite = CacheGif:create(CCFileUtils:sharedFileUtils():fullPathForFilename(path))
	end
	local x = t.x or 0
	local y = t.y or 0
	self.sprite:setPosition(CCPointMake(x, y))
end
