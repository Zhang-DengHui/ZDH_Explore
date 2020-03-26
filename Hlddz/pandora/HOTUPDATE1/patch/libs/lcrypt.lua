lcrypt = {}

do
  --  
  --  Adaptation of the Secure Hashing Algorithm (SHA-244/256)
  --  Found Here: http://lua-users.org/wiki/SecureHashAlgorithm
  --  
  --  Using an adapted version of the bit library
  --  Found Here: https://bitbucket.org/Boolsheet/bslf/src/1ee664885805/bit.lua
  --  
  
  local MOD = 2^32
  local MODM = MOD-1
  
  local function memoize(f)
    local mt = {}
    local t = setmetatable({}, mt)
    function mt:__index(k)
      local v = f(k)
      t[k] = v
      return v
    end
    return t
  end
  
  local function make_bitop_uncached(t, m)
    local function bitop(a, b)
      local res,p = 0,1
      while a ~= 0 and b ~= 0 do
        local am, bm = a % m, b % m
        res = res + t[am][bm] * p
        a = (a - am) / m
        b = (b - bm) / m
        p = p*m
      end
      res = res + (a + b) * p
      return res
    end
    return bitop
  end
  
  local function make_bitop(t)
    local op1 = make_bitop_uncached(t,2^1)
    local op2 = memoize(function(a) return memoize(function(b) return op1(a, b) end) end)
    return make_bitop_uncached(op2, 2 ^ (t.n or 1))
  end
  
  local bxor1 = make_bitop({[0] = {[0] = 0,[1] = 1}, [1] = {[0] = 1, [1] = 0}, n = 4})
  
  local function bxor(a, b, c, ...)
    local z = nil
    if b then
      a = a % MOD
      b = b % MOD
      z = bxor1(a, b)
      if c then z = bxor(z, c, ...) end
      return z
    elseif a then return a % MOD
    else return 0 end
  end
  
  local function band(a, b, c, ...)
    local z
    if b then
      a = a % MOD
      b = b % MOD
      z = ((a + b) - bxor1(a,b)) / 2
      if c then z = bit32_band(z, c, ...) end
      return z
    elseif a then return a % MOD
    else return MODM end
  end
  
  local function bnot(x) return (-1 - x) % MOD end
  
  local function rshift1(a, disp)
    if disp < 0 then return lshift(a,-disp) end
    return math.floor(a % 2 ^ 32 / 2 ^ disp)
  end
  
  local function rshift(x, disp)
    if disp > 31 or disp < -31 then return 0 end
    return rshift1(x % MOD, disp)
  end
  
  local function lshift(a, disp)
    if disp < 0 then return rshift(a,-disp) end 
    return (a * 2 ^ disp) % 2 ^ 32
  end
  
  local function rrotate(x, disp)
      x = x % MOD
      disp = disp % 32
      local low = band(x, 2 ^ disp - 1)
      return rshift(x, disp) + lshift(low, 32 - disp)
  end
  
  local k = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
  }
  
  local function str2hexa(s)
    return (string.gsub(s, ".", function(c) return string.format("%02x", string.byte(c)) end))
  end
  
  local function num2s(l, n)
    local s = ""
    for i = 1, n do
      local rem = l % 256
      s = string.char(rem) .. s
      l = (l - rem) / 256
    end
    return s
  end
  
  local function s232num(s, i)
    local n = 0
    for i = i, i + 3 do n = n*256 + string.byte(s, i) end
    return n
  end
  
  local function preproc(msg, len)
    local extra = 64 - ((len + 9) % 64)
    len = num2s(8 * len, 8)
    msg = msg .. "\128" .. string.rep("\0", extra) .. len
    assert(#msg % 64 == 0)
    return msg
  end
  
  local function initH256(H)
    H[1] = 0x6a09e667
    H[2] = 0xbb67ae85
    H[3] = 0x3c6ef372
    H[4] = 0xa54ff53a
    H[5] = 0x510e527f
    H[6] = 0x9b05688c
    H[7] = 0x1f83d9ab
    H[8] = 0x5be0cd19
    return H
  end
  
  local function digestblock(msg, i, H)
    local w = {}
    for j = 1, 16 do w[j] = s232num(msg, i + (j - 1)*4) end
    for j = 17, 64 do
      local v = w[j - 15]
      local s0 = bxor(rrotate(v, 7), rrotate(v, 18), rshift(v, 3))
      v = w[j - 2]
      w[j] = w[j - 16] + s0 + w[j - 7] + bxor(rrotate(v, 17), rrotate(v, 19), rshift(v, 10))
    end
  
    local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
    for i = 1, 64 do
      local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
      local maj = bxor(band(a, b), band(a, c), band(b, c))
      local t2 = s0 + maj
      local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
      local ch = bxor (band(e, f), band(bnot(e), g))
      local t1 = h + s1 + ch + k[i] + w[i]
      h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
    end
  
    H[1] = band(H[1] + a)
    H[2] = band(H[2] + b)
    H[3] = band(H[3] + c)
    H[4] = band(H[4] + d)
    H[5] = band(H[5] + e)
    H[6] = band(H[6] + f)
    H[7] = band(H[7] + g)
    H[8] = band(H[8] + h)
  end
  
  local function sha256(msg)
    msg = preproc(msg, #msg)
    local H = initH256({})
    for i = 1, #msg, 64 do digestblock(msg, i, H) end
    return str2hexa(num2s(H[1], 4) .. num2s(H[2], 4) .. num2s(H[3], 4) .. num2s(H[4], 4) ..
      num2s(H[5], 4) .. num2s(H[6], 4) .. num2s(H[7], 4) .. num2s(H[8], 4))
  end
  
  lcrypt.sha256 = sha256
end

do
  local md5 = {
    _VERSION     = "md5.lua 1.1.0",
    _DESCRIPTION = "MD5 computation in Lua (5.1-3, LuaJIT)",
    _URL         = "https://github.com/kikito/md5.lua",
    _LICENSE     = [[
      MIT LICENSE
  
      Copyright (c) 2013 Enrique García Cota + Adam Baldwin + hanzao + Equi 4 Software
  
      Permission is hereby granted, free of charge, to any person obtaining a
      copy of this software and associated documentation files (the
      "Software"), to deal in the Software without restriction, including
      without limitation the rights to use, copy, modify, merge, publish,
      distribute, sublicense, and/or sell copies of the Software, and to
      permit persons to whom the Software is furnished to do so, subject to
      the following conditions:
  
      The above copyright notice and this permission notice shall be included
      in all copies or substantial portions of the Software.
  
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
      OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
      IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
      CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
      SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    ]]
  }
  
  local char, byte, format, rep, sub = string.char, string.byte, string.format, string.rep, string.sub
  local floor, max, abs = math.floor, math.max, math.abs
  
  -- bit lib implementions
  local trim, to_bits, tbl2number, expand
  local bit_or, bit_and, bit_not, bit_xor, bit_rshift, bit_lshift, bit_rrotate, bit_lrotate
  local bitn_and, bitn_or, bitn_xor
  
  trim = function(n)
    return bit_and(n, 0xFFFFFFFF)
  end
  
  tbl2number = function(tbl)
    local result = 0
    local power = 1
    for i = 1, #tbl do
      result = result + tbl[i] * power
      power = power * 2
    end
    return result
  end
  
  expand = function(t1, t2)
    local big, small = t1, t2
    if(#big < #small) then
      big, small = small, big
    end
    -- expand small
    for i = #small + 1, #big do
      small[i] = 0
    end
  end
  
  bit_not = function(n)
    local tbl = to_bits(n)
    local size = max(#tbl, 32)
    for i = 1, size do
      if(tbl[i] == 1) then
        tbl[i] = 0
      else
        tbl[i] = 1
      end
    end
    return tbl2number(tbl)
  end
  
  to_bits = function (n)
    if(n < 0) then
      -- negative
      return to_bits(bit_not(abs(n)) + 1)
    end
    -- to bits table
    local tbl = {}
    local cnt = 1
    local last
    while n > 0 do
      last      = n % 2
      tbl[cnt]  = last
      n         = (n-last)/2
      cnt       = cnt + 1
    end
  
    return tbl
  end
  
  bit_or = function(m, n)
    local tbl_m = to_bits(m)
    local tbl_n = to_bits(n)
    expand(tbl_m, tbl_n)
  
    local tbl = {}
    for i = 1, #tbl_m do
      if(tbl_m[i]== 0 and tbl_n[i] == 0) then
        tbl[i] = 0
      else
        tbl[i] = 1
      end
    end
  
    return tbl2number(tbl)
  end
  
  bit_and = function(m, n)
    local tbl_m = to_bits(m)
    local tbl_n = to_bits(n)
    expand(tbl_m, tbl_n)
  
    local tbl = {}
    for i = 1, #tbl_m do
      if(tbl_m[i]== 0 or tbl_n[i] == 0) then
        tbl[i] = 0
      else
        tbl[i] = 1
      end
    end
  
    return tbl2number(tbl)
  end
  
  bit_xor = function(m, n)
    local tbl_m = to_bits(m)
    local tbl_n = to_bits(n)
    expand(tbl_m, tbl_n)
  
    local tbl = {}
    for i = 1, #tbl_m do
      if(tbl_m[i] ~= tbl_n[i]) then
        tbl[i] = 1
      else
        tbl[i] = 0
      end
    end
  
    return tbl2number(tbl)
  end
  
  bit_rshift = function(n, bits)
    local high_bit = 0
    if(n < 0) then
      -- negative
      n = bit_not(abs(n)) + 1
      high_bit = 0x80000000
    end
  
    for i=1, bits do
      n = n/2
      n = bit_or(floor(n), high_bit)
    end
    return trim(floor(n))
  end
  
  bit_lshift = function(n, bits)
    if(n < 0) then
      -- negative
      n = bit_not(abs(n)) + 1
    end
  
    for i=1, bits do
      n = n*2
    end
    return trim(n)
  end
  
  -- convert little-endian 32-bit int to a 4-char string
  local function lei2str(i)
    local f=function (s) return char( bit_and( bit_rshift(i, s), 255)) end
    return f(0)..f(8)..f(16)..f(24)
  end
  
  -- convert raw string to big-endian int
  local function str2bei(s)
    local v=0
    for i=1, #s do
      v = v * 256 + byte(s, i)
    end
    return v
  end
  
  -- convert raw string to little-endian int
  local function str2lei(s)
    local v=0
    for i = #s,1,-1 do
      v = v*256 + byte(s, i)
    end
    return v
  end
  
  -- cut up a string in little-endian ints of given size
  local function cut_le_str(s,...)
    local o, r = 1, {}
    local args = {...}
    for i=1, #args do
      table.insert(r, str2lei(sub(s, o, o + args[i] - 1)))
      o = o + args[i]
    end
    return r
  end
  
  local swap = function (w) return str2bei(lei2str(w)) end
  
  -- An MD5 mplementation in Lua, requires bitlib (hacked to use LuaBit from above, ugh)
  -- 10/02/2001 jcw@equi4.com
  
  local CONSTS = {
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
    0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
  }
  
  local f=function (x,y,z) return bit_or(bit_and(x,y),bit_and(-x-1,z)) end
  local g=function (x,y,z) return bit_or(bit_and(x,z),bit_and(y,-z-1)) end
  local h=function (x,y,z) return bit_xor(x,bit_xor(y,z)) end
  local i=function (x,y,z) return bit_xor(y,bit_or(x,-z-1)) end
  local z=function (ff,a,b,c,d,x,s,ac)
    a=bit_and(a+ff(b,c,d)+x+ac,0xFFFFFFFF)
    -- be *very* careful that left shift does not cause rounding!
    return bit_or(bit_lshift(bit_and(a,bit_rshift(0xFFFFFFFF,s)),s),bit_rshift(a,32-s))+b
  end
  
  local function transform(A,B,C,D,X)
    local a,b,c,d=A,B,C,D
    local t=CONSTS
  
    a=z(f,a,b,c,d,X[ 0], 7,t[ 1])
    d=z(f,d,a,b,c,X[ 1],12,t[ 2])
    c=z(f,c,d,a,b,X[ 2],17,t[ 3])
    b=z(f,b,c,d,a,X[ 3],22,t[ 4])
    a=z(f,a,b,c,d,X[ 4], 7,t[ 5])
    d=z(f,d,a,b,c,X[ 5],12,t[ 6])
    c=z(f,c,d,a,b,X[ 6],17,t[ 7])
    b=z(f,b,c,d,a,X[ 7],22,t[ 8])
    a=z(f,a,b,c,d,X[ 8], 7,t[ 9])
    d=z(f,d,a,b,c,X[ 9],12,t[10])
    c=z(f,c,d,a,b,X[10],17,t[11])
    b=z(f,b,c,d,a,X[11],22,t[12])
    a=z(f,a,b,c,d,X[12], 7,t[13])
    d=z(f,d,a,b,c,X[13],12,t[14])
    c=z(f,c,d,a,b,X[14],17,t[15])
    b=z(f,b,c,d,a,X[15],22,t[16])
  
    a=z(g,a,b,c,d,X[ 1], 5,t[17])
    d=z(g,d,a,b,c,X[ 6], 9,t[18])
    c=z(g,c,d,a,b,X[11],14,t[19])
    b=z(g,b,c,d,a,X[ 0],20,t[20])
    a=z(g,a,b,c,d,X[ 5], 5,t[21])
    d=z(g,d,a,b,c,X[10], 9,t[22])
    c=z(g,c,d,a,b,X[15],14,t[23])
    b=z(g,b,c,d,a,X[ 4],20,t[24])
    a=z(g,a,b,c,d,X[ 9], 5,t[25])
    d=z(g,d,a,b,c,X[14], 9,t[26])
    c=z(g,c,d,a,b,X[ 3],14,t[27])
    b=z(g,b,c,d,a,X[ 8],20,t[28])
    a=z(g,a,b,c,d,X[13], 5,t[29])
    d=z(g,d,a,b,c,X[ 2], 9,t[30])
    c=z(g,c,d,a,b,X[ 7],14,t[31])
    b=z(g,b,c,d,a,X[12],20,t[32])
  
    a=z(h,a,b,c,d,X[ 5], 4,t[33])
    d=z(h,d,a,b,c,X[ 8],11,t[34])
    c=z(h,c,d,a,b,X[11],16,t[35])
    b=z(h,b,c,d,a,X[14],23,t[36])
    a=z(h,a,b,c,d,X[ 1], 4,t[37])
    d=z(h,d,a,b,c,X[ 4],11,t[38])
    c=z(h,c,d,a,b,X[ 7],16,t[39])
    b=z(h,b,c,d,a,X[10],23,t[40])
    a=z(h,a,b,c,d,X[13], 4,t[41])
    d=z(h,d,a,b,c,X[ 0],11,t[42])
    c=z(h,c,d,a,b,X[ 3],16,t[43])
    b=z(h,b,c,d,a,X[ 6],23,t[44])
    a=z(h,a,b,c,d,X[ 9], 4,t[45])
    d=z(h,d,a,b,c,X[12],11,t[46])
    c=z(h,c,d,a,b,X[15],16,t[47])
    b=z(h,b,c,d,a,X[ 2],23,t[48])
  
    a=z(i,a,b,c,d,X[ 0], 6,t[49])
    d=z(i,d,a,b,c,X[ 7],10,t[50])
    c=z(i,c,d,a,b,X[14],15,t[51])
    b=z(i,b,c,d,a,X[ 5],21,t[52])
    a=z(i,a,b,c,d,X[12], 6,t[53])
    d=z(i,d,a,b,c,X[ 3],10,t[54])
    c=z(i,c,d,a,b,X[10],15,t[55])
    b=z(i,b,c,d,a,X[ 1],21,t[56])
    a=z(i,a,b,c,d,X[ 8], 6,t[57])
    d=z(i,d,a,b,c,X[15],10,t[58])
    c=z(i,c,d,a,b,X[ 6],15,t[59])
    b=z(i,b,c,d,a,X[13],21,t[60])
    a=z(i,a,b,c,d,X[ 4], 6,t[61])
    d=z(i,d,a,b,c,X[11],10,t[62])
    c=z(i,c,d,a,b,X[ 2],15,t[63])
    b=z(i,b,c,d,a,X[ 9],21,t[64])
  
    return bit_and(A+a,0xFFFFFFFF),bit_and(B+b,0xFFFFFFFF),
           bit_and(C+c,0xFFFFFFFF),bit_and(D+d,0xFFFFFFFF)
  end
  
  ----------------------------------------------------------------
  
  local function md5_update(self, s)
    self.pos = self.pos + #s
    s = self.buf .. s
    for ii = 1, #s - 63, 64 do
      local X = cut_le_str(sub(s,ii,ii+63),4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)
      assert(#X == 16)
      X[0] = table.remove(X,1) -- zero based!
      self.a,self.b,self.c,self.d = transform(self.a,self.b,self.c,self.d,X)
    end
    self.buf = sub(s, math.floor(#s/64)*64 + 1, #s)
    return self
  end
  
  local function md5_finish(self)
    local msgLen = self.pos
    local padLen = 56 - msgLen % 64
  
    if msgLen % 64 > 56 then padLen = padLen + 64 end
  
    if padLen == 0 then padLen = 64 end
  
    local s = char(128) .. rep(char(0),padLen-1) .. lei2str(bit_and(8*msgLen, 0xFFFFFFFF)) .. lei2str(math.floor(msgLen/0x20000000))
    md5_update(self, s)
  
    assert(self.pos % 64 == 0)
    return lei2str(self.a) .. lei2str(self.b) .. lei2str(self.c) .. lei2str(self.d)
  end
  
  ----------------------------------------------------------------
  
  function md5.new()
    return { a = CONSTS[65], b = CONSTS[66], c = CONSTS[67], d = CONSTS[68],
             pos = 0,
             buf = '',
             update = md5_update,
             finish = md5_finish }
  end
  
  function md5.tohex(s)
    return format("%08x%08x%08x%08x", str2bei(sub(s, 1, 4)), str2bei(sub(s, 5, 8)), str2bei(sub(s, 9, 12)), str2bei(sub(s, 13, 16)))
  end
  
  function md5.sum(s)
    return md5.new():update(s):finish()
  end
  
  function md5.sumhexa(s)
    return md5.tohex(md5.sum(s))
  end
  
  lcrypt.md5 = md5
end

--[[
print(lcrypt.sha256("Shanghai"))
-- output:303b1fa993cf8945b7aa53666deef39f1505230ece1338d809199c302b4b9194
print(lcrypt.md5.sumhexa("Shanghai"))
-- output:5466ee572bcbc75830d044e66ab429bc
]]