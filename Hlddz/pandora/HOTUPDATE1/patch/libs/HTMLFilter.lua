HTMLFilter = {}

local f = {}
f["&nbsp;"] = " "
f["&lsquo;"] = "‘"
f["&rsquo;"] = "’"
f["&ndash;"] = "–"
f["&sbquo;"] = "‚"
f["&ldquo;"] = "“"
f["&rdquo;"] = "”"
f["&bdquo;"] = "„"
f["&mdash;"] = "—"
f["&laquo;"] = "«"
f["&raquo;"] = "»"
f["&dagger;"] = "†"
f["&Dagger;"] = "‡"
f["&permil;"] = "‰"
f["&lsaquo;"] = "‹"
f["&rsaquo;"] = "›"
f["&hellip;"] = "…"
f["&bull;"] = "•"
f["&prime;"] = "′"
f["&oline;"] = "‾"
f["&frasl;"] = "⁄"
f["&yen;"] = "¥"
f["&plusmn;"] = "±"
f["&middot;"] = "·"
f["&sect;"] = "§"


function HTMLFilter.translate( html)
	if html == nil or html == "" then
		return ""
	end
	 local r,_= string.gsub(html,"&%a+;",function(it)
	 	Log.i("sub begin"..it)
        local r=f[it]
        return r and r or it
    end)

	return r
end
