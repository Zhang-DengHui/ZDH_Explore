Vector3 = {}

local Matrix3x3={}
local Vector3=Vector3

local setmetatable=setmetatable
local getmetatable=getmetatable
local type=type
local acos=math.acos
local sin=math.sin
local cos=math.cos
local sqrt=math.sqrt
local error=error
local min=math.min
local max=math.max
local abs=math.abs
local pow=math.pow

local ToAngle=57.29578
local ToRad=0.01745329
local Epsilon=0.00001
local Infinite=1/0
local Sqrt2=0.7071067811865475244008443621048490
local PI=3.14159265358979323846264338327950

local function clamp(v,min,max)
	min = min or 0
	max = max or 1
	return v>max and max or (v<min and min or v)
end

local function lerpf(a,b,t)
	t=clamp(t,0,1)
	return a+(b-a)*t
end

local function inherite(cls,base)
	for k,v in pairs(getmetatable(base)) do
		if k:sub(1,2)~='__' and  k:sub(1,1)>='A' and k:sub(1,1)<='Z' then
			cls[k]=v
		end
	end
end

do
	function Matrix3x3.SetAt(m,row,col,v)
		m[row*3+col+1]=v
	end

	function Matrix3x3.New()
		local r={1,0,0,0,1,0,0,0,1}
		setmetatable(r,Matrix3x3)
		return r
	end

	function Matrix3x3.__tostring(m)
		return string.format('Matrix3x3(%f,%f,%f,%f,%f,%f,%f,%f,%f)'
			,m[1],m[2],m[3]
			,m[4],m[5],m[6]
			,m[7],m[8],m[9])
	end

	function Matrix3x3.SetAxisAngle(m,axis,rad)
		-- This function contributed by Erich Boleyn (erich@uruk.org) */
		-- This function used from the Mesa OpenGL code (matrix.c)  */
		local s, c
		local vx, vy, vz, xx, yy, zz, xy, yz, zx, xs, ys, zs, one_c

		s = sin (rad)
		c = cos (rad)

		vx = axis[1]
		vy = axis[2]
		vz = axis[3]

		xx = vx * vx
		yy = vy * vy
		zz = vz * vz
		xy = vx * vy
		yz = vy * vz
		zx = vz * vx
		xs = vx * s
		ys = vy * s
		zs = vz * s
		one_c = 1.0 - c
		local Set=Matrix3x3.SetAt
		Set(m,0,0, (one_c * xx) + c )
		Set(m,1,0, (one_c * xy) - zs)
		Set(m,2,0, (one_c * zx) + ys)
		Set(m,0,1, (one_c * xy) + zs)
		Set(m,1,1, (one_c * yy) + c )
		Set(m,2,1, (one_c * yz) - xs)
		Set(m,0,2, (one_c * zx) - ys)
		Set(m,1,2, (one_c * yz) + xs)
		Set(m,2,2, (one_c * zz) + c )
	end

	function Matrix3x3.Mul(m,v)
		local res=Vector3.New(0,0,0)
		res[1] = m[1] * v[1] + m[4] * v[2] + m[7] * v[3]
		res[2] = m[2] * v[1] + m[5] * v[2] + m[8] * v[3]
		res[3] = m[3] * v[1] + m[6] * v[2] + m[9] * v[3]
		return res
	end

	function Matrix3x3:SetIdentity()
		self[1],self[2],self[3]=1,0,0
		self[4],self[5],self[6]=0,1,0
		self[7],self[8],self[9]=0,0,1
	end

	function Matrix3x3:SetOrthoNormal( x,y,z )
		self[1],self[2],self[3]=x[1],y[1],z[1]
		self[4],self[5],self[6]=x[2],y[2],z[2]
		self[7],self[8],self[9]=x[3],y[3],z[3]
	end
end

do
	Vector3.__typename = 'Vector3'
	local T = Vector3
	local I = {}
	I.__typename = T.__typename
	local get={}
	local set={}

	Vector3.__index = function(t,k)
		local f=rawget(Vector3,k)
		if f then return f end
		local f=rawget(get,k)
		if f then return f(t) end
		error('Not found '..k)
	end

	Vector3.__newindex = function(t,k,v)
		local f=rawget(set,k)
		if f then return f(t,v) end
		error('Not found '..k)
	end

	Vector3.New=function (x,y,z)
		local v={x or 0,y or 0,z or 0}
		setmetatable(v,I)
		return v
	end

	Vector3.__call = function(t,x,y,z)
		return Vector3.New(x,y,z)
	end

	I.__index = function(t,k)
		local f=rawget(I,k)
		if f then return f end
		local f=rawget(get,k)
		if f then return f(t) end
		error('Not found '..k)
	end

	I.__newindex = function(t,k,v)
		local f=rawget(set,k)
		if f then return f(t,v) end
		error('Not found '..k)
	end

	I.__eq = function(a,b)
		return abs(a[1]-b[1])<Epsilon
		 	and abs(a[2]-b[2])<Epsilon
		 	and abs(a[3]-b[3])<Epsilon
	end

	I.__unm = function(a)
		local ca=Vector3.New(-a[1],-a[2],-a[3])
		return ca
	end

	I.__tostring = function(self)
		return string.format('Vector3(%f,%f,%f)',self[1],self[2],self[3])
	end

	I.__mul = function(a,b)
		local ta=type(a)
		local tb=type(b)
		if ta=='table' and tb=='number' then
			return Vector3.New(a[1]*b,a[2]*b,a[3]*b)
		elseif ta=='number' and tb=='table' then
			return Vector3.New(a*b[1],a*b[2],a*b[3])
		else
			error(string.format('unexpect type of arguments, got %s,%s',ta,tb))
		end
	end

	I.__add = function(a,b)
		return Vector3.New(a[1]+b[1],a[2]+b[2],a[3]+b[3])
	end

	I.__sub = function(a,b)
		return Vector3.New(a[1]-b[1],a[2]-b[2],a[3]-b[3])
	end

	I.__div = function(a,b)
		return Vector3.New(a[1]/b,a[2]/b,a[3]/b)
	end

	function Vector3.Mul(self,b)
		self[1],self[2],self[3]=self[1]*b,self[2]*b,self[3]*b
	end

	function Vector3.Add(self,b)
		self[1],self[2],self[3]=self[1]+b[1],self[2]+b[2],self[3]+b[3]
	end

	function Vector3.Sub(self,b)
		self[1],self[2],self[3]=self[1]-b[1],self[2]-b[2],self[3]-b[3]
	end

	function Vector3.Div(self,b)
		self[1],self[2],self[3]=self[1]/b,self[2]/b,self[3]/b
	end

	function get.back() return Vector3.New(0,0,-1) end
	function get.down() return Vector3.New(0,-1,0) end
	function get.forward() return Vector3.New(0,0,1) end
	function get.left() return Vector3.New(-1,0,0) end
	function get.one() return Vector3.New(1,1,1) end
	function get.right() return Vector3.New(1,0,0) end
	function get.up() return Vector3.New(0,1,0) end
	function get.zero() return Vector3.New(0,0,0) end

	function get:x() return self[1] end
	function get:y() return self[2] end
	function get:z() return self[3] end
	function set:x(v) self[1]=v end
	function set:y(v) self[2]=v end
	function set:z(v) self[3]=v end
	function get:magnitude() return Vector3.Magnitude(self) end
	function get:sqrMagnitude() return Vector3.SqrMagnitude(self) end
	function get:normalized() return Vector3.Normalize(self) end

	function Vector3:Clone()
		return Vector3.New(self[1],self[2],self[3])
	end
		
	function I:Set(x,y,z)	
		self[1],self[2],self[3]=x or 0,y or 0,z or 0
	end

	function I:ToString()
		return self:__tostring()
	end

	function Vector3.Angle(a,b)
		local dot = Vector3.Dot(Vector3.Normalize(a), Vector3.Normalize(b))
		return acos(dot)*ToAngle
	end

	function Vector3.Normalized(v)
		local m = Vector3.Magnitude(v)
		if m==1 then
			return v
		elseif m>Epsilon then
			v[1],v[2],v[3]=v[1]/m,v[2]/m,v[3]/m
		else
			v:Set(0,0,0)
		end
	end

    function Vector3.Normalize(v)
        local v=Vector3.Clone(v)
        Vector3.Normalized(v)
        return v
	end

	function I:Normalize()
		Vector3.Normalized(self)
	end

	function Vector3.Magnitude(v)
		local v= sqrt(v[1]^2+v[2]^2+v[3]^2)
		return v
	end

	function Vector3.SqrMagnitude(v)
		local v= v[1]^2+v[2]^2+v[3]^2
		return v
	end

	function Vector3.Dot(a,b)
		local v= a[1]*b[1] + a[2]*b[2] + a[3]*b[3]
		return v
	end

	function Vector3.Cross(a,b)
		return Vector3.New((a[2] * b[3]) - (a[3] * b[2])
			, (a[3] * b[1]) - (a[1] * b[3])
			, (a[1] * b[2]) - (a[2] * b[1]))
	end

	function Vector3.OrthoNormalVector(n)
		local res=Vector3.New(0,0,0)
		if abs(n[3]) > Sqrt2 then
			local a = n[2]^2 + n[3]^2
			local k = 1 / sqrt (a)
			res[1],res[2],res[3] = 0,-n[3]*k,n[2]*k
		else
			local a = n[1]^2 + n[2]^2
			local k = 1 / sqrt (a)
			res[1],res[2],res[3] = -n[2]*k,n[1]*k,0
		end
		return res
	end

	function Vector3.Slerp(a,b,t)
		if t<=0 then return Vector3.Clone(a) end
		if t>=1 then return Vector3.Clone(b) end

		local ma=Vector3.Magnitude(a)
		local mb=Vector3.Magnitude(b)
		if ma<Epsilon or mb<Epsilon then
			return Vector3.Lerp(a,b,t)
		end

		local dot=Vector3.Dot(a,b)/(ma*mb)
		if dot>1-Epsilon then
			return Vector3.Lerp(a,b,t)
		elseif dot<-1+Epsilon then
			local lerpedMagnitude = lerpf (ma, mb, t)
			local na = I.__div(a,ma)
			local axis = Vector3.OrthoNormalVector(na)
			local m=Matrix3x3.New()
			Matrix3x3.SetAxisAngle(m,axis,PI*t)
			local slerped = Matrix3x3.Mul(m,na)
			Vector3.Mul(slerped,lerpedMagnitude)
			return slerped
		else
			local lerpedMagnitude = lerpf (ma, mb, t)
			local axis = Vector3.Cross(a,b)
			local na = a/ma
			Vector3.Normalized(axis)
			local angle=acos(dot)*t
			local m=Matrix3x3.New()
			Matrix3x3.SetAxisAngle(m,axis,angle)
			local slerped = Matrix3x3.Mul(m,na)
			Vector3.Mul(slerped,lerpedMagnitude)
			return slerped
		end
	end

	function Vector3.Lerp(a,b,t)
		return Vector3.New(a[1]+(b[1]-a[1])*t
			,a[2]+(b[2]-a[2])*t
			,a[3]+(b[3]-a[3])*t
		)
	end

	function Vector3.Min(a,b)
		return Vector3.New(min(a[1],b[1])
			,min(a[2],b[2])
			,min(a[3],b[3]))
	end

	function Vector3.Max(a,b)
		return Vector3.New(max(a[1],b[1])
			,max(a[2],b[2])
			,max(a[3],b[3]))
	end

	function Vector3.MoveTowards(a,b,adv)
		local v = I.__sub(b,a)
		local m = Vector3.Magnitude(v)
		if m>adv and m~=0 then
			Vector3.Div(v,m)
			Vector3.Mul(v,adv)
			Vector3.Add(v,a)
			return v
		end
		return Vector3.Clone(b)
	end

	local function ClampedMove(a,b,mag)
		local delta = b-a
		if delta > 0 then
			return a + min (delta, mag)
		else
			return a - min (-delta, mag)
		end
	end

	function Vector3.RotateTowards(a,b,angleMove,mag)
		local ma = Vector3.Magnitude(a)
		local mb = Vector3.Magnitude(b)
		
		if ma > Epsilon and mb > Epsilon then
			local na = a / ma
			local nb = b / mb
			
			local dot = Vector3.Dot(na, nb)
			if dot > 1.0 - Epsilon then
				return Vector3.MoveTowards (a, b, mag)
			elseif dot < -1.0 + Epsilon then
				local axis = Vector3.OrthoNormalVector(na)
				local m=Matrix3x3.New()
				Matrix3x3.SetAxisAngle(m, axis, angleMove)
				local rotated = Matrix3x3.Mul(m,na)
				Vector3.Mul(rotated,ClampedMove(ma, mb, mag))
				return rotated
			else
				local angle = acos(dot);
				local axis = Vector3.Cross(na, nb)
				Vector3.Normalized(axis)
				local m=Matrix3x3.New()
				Matrix3x3.SetAxisAngle(m,axis, min(angleMove, angle))
				local rotated = Matrix3x3.Mul(m,na)
				Vector3.Mul(rotated,ClampedMove(ma, mb, mag))
				return rotated
			end
		else
			return Vector3.MoveTowards (a,b,mag)
		end
	end

	function Vector3.Distance(a,b)
		a=Vector3.Clone(a)
		Vector3.Sub(a,b)
		return Vector3.Magnitude(a)
	end

	function Vector3.OrthoNormalize(u,v,w)
		Vector3.Normalized(u)

		local dot0 = Vector3.Dot(u,v)
		local tu=Vector3.Clone(u)
		Vector3.Mul(tu,dot0)
		Vector3.Sub(v,tu)
		Vector3.Normalized(v)

		if w then
			local dot1 = Vector3.Dot(v,w)
			local dot0 = Vector3.Dot(u,w)
			local tw=I.__mul(u,dot0)
			local tv=I.__mul(v,dot1)
			Vector3.Add(tv,tw)
			Vector3.Sub(w,tv)
			Vector3.Normalized(w)
		end
	end

	function Vector3.Scale(a,b)
		return Vector3.New(a[1]*b[1],a[2]*b[2],a[3]*b[3])
	end

	function I:Scale( self,b )
		return Vector3.Scale(self,b)
	end

	function Vector3.SmoothDamp(current,target,currentVelocity,smoothTime,maxSpeed,deltaTime)
		smoothTime = max(Epsilon,smoothTime)
		local float num = 2 / smoothTime
	    local float num2 = num * deltaTime
	    local float num3 = 1 / (((1 + num2) + ((0.48 * num2) * num2)) + (((0.235 * num2) * num2) * num2))
	    local vector = current - target;
	    local vector2 = target
	    local maxLength = maxSpeed * smoothTime
	    vector = Vector3.ClampMagnitude(vector, maxLength)
	    target = current - vector
	    local vector3 = currentVelocity +  vector * deltaTime * num
	    local newv = currentVelocity -  vector3 * num3 * num
	    local vector4 = target + (vector + vector3) * num3
	    if Vector3.Dot(vector2 - current, vector4 - vector2) > 0 then
	        vector4 = vector2
	        newv = (vector4 - vector2) / deltaTime
	    end
	    currentVelocity:Set(newv.x,newv.y,newv.z)
	    return vector4,currentVelocity
	end

	function Vector3.ClampMagnitude(vector,maxLength)
	    if Vector3.SqrMagnitude(vector) > (maxLength^2) then
	        return vector.normalized * maxLength
	    end
	    return Vector3.Clone(vector)
	end

	function Vector3.Reflect(dir,nml)
		local dot=Vector3.Dot(nml,dir)*-2
		local v=I.__mul(nml,dot)
		Vector3.Add(v,dir)
		return v
	end

	function Vector3.ProjectOnPlane(vector,planeNormal)
		return vector - Vector3.Project(vector, planeNormal)
	end

	function Vector3.Project( vector,normal )
		local num = Vector3.Dot(normal, normal)
	    if num < Epsilon then
	        return Vector3.zero
	    end
	    return (normal * Vector3.Dot(vector, normal)) / num
	end

	setmetatable(Vector3,Vector3)
end
