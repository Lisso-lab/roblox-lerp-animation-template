local run_service = game:GetService('RunService')
local plrs,workspace = game:GetService('Players'),game:GetService('Workspace')

local plr,char = plrs.LocalPlayer,plrs.LocalPlayer.Character
local hrp,tor,hum = char.HumanoidRootPart,char.Torso,char.Humanoid

local start_id = '930541401'
local id_volume = 1
local fps = 1/60
local pitch = 1
local sine = 0

local raycast_params = RaycastParams.new()

local V3 = {n=Vector3.new}
local CF = {n=CFrame.new, a=CFrame.Angles}
local IT = {n=Instance.new}

local motors    = {}
local animations = {}
local commands  = {}

local C0s = {
	['Right Shoulder'] = CF.n(1.5,.5,0),
	['Left Shoulder']  = CF.n(-1.5,.5,0),
	['Right Hip']      = CF.n(.5,-1,0),
	['Left Hip']       = CF.n(-.5,-1,0),
	['Neck']           = CF.n(0,1.5,0),
	['RootJoint']      = CF.n(0,0,0)
}

local C1s = {
	['Right Shoulder'] = CF.n(0,.5,0),
	['Left Shoulder']  = CF.n(0,.5,0),
	['Right Hip']      = CF.n(0,1,0),
	['Left Hip']       = CF.n(0,1,0),
	['Neck']           = CF.n(0,0,0),
	['RootJoint']      = CF.n(0,0,0)
}

local function add_hat_for_anim(naming,handle,part1,c0,c1)
	if handle:FindFirstChild('AccessoryWeld') then
		handle.AccessoryWeld:Destroy()
	end

	local motor = IT.n('Motor6D')
	motor.Part0 = handle
	motor.Part1 = part1 
	motor.C0 = c0 or CF.n()
	motor.C1 = c1 or CF.n()
	motor.Parent = handle

	motors[naming] = motor
end

local function s_rename(string)
    local split = string.split(string ,' ')
    local only_uppers = string.gsub(string ,'%l+','')
    
    if split[2] then
        local string = ''
        
        for i=1,#split do
            string = string ..string.sub(split[i],1,1)
        end

        return string.upper(string)

    elseif string.len(only_uppers) >= 2 then
        return only_uppers
    
    else
        return string
    end
end

local function cos(speed)
	return math.cos(sine/speed)
end

local function sin(speed)
	return math.sin(sine/speed)
end

local function ray_cast(from,direction)
	return workspace:Raycast(
		from,
        direction,
		raycast_params
	)
end

local function actual_lerp(a ,b ,t)
	return a + (b-a) * t
end

local function lerp(motor,cf,angles,alpha)
    local x,y,z = motors[motor].Transform:ToEulerAnglesXYZ()

    motors[motor].Transform = (CF.n(
        actual_lerp(motors[motor].Transform.X ,cf[1] ,alpha),
        actual_lerp(motors[motor].Transform.Y ,cf[2] ,alpha),
        actual_lerp(motors[motor].Transform.Z ,cf[3] ,alpha)
    ) * CF.a(
        actual_lerp(x ,angles[1] ,alpha),
        actual_lerp(y ,angles[2] ,alpha),
        actual_lerp(z ,angles[3] ,alpha)
    ))
end

local function get_state()
	local hrp_velocity = (hrp.Velocity * V3.n(1,0,1)).magnitude
	local hrp_vel_up = hrp.Velocity.y

	local hitfloor = ray_cast(
		hrp.Position,
		((CF.n(hrp.Position,hrp.Position - V3.n(0,1,0))).lookVector).unit * 4
	)

    if hitfloor then
        if hrp_velocity<1 then
            return 'idle'

        elseif hrp_velocity>2 then
            return 'walking'

        else
            return 'idle'
        end
    else
        if hrp_vel_up >1 then
            return 'jump' 

        elseif hrp_vel_up <-1 then
            return 'fall' 

        else
            return 'idle'
        end
    end
end

local function get_rv_lv()
    local rightvector = (hrp.Velocity*tor.CFrame.rightVector).X + (hrp.Velocity*tor.CFrame.rightVector).Z
    local lookvector  = (hrp.Velocity*tor.CFrame.lookVector).X  + (hrp.Velocity*tor.CFrame.lookVector).Z
    
    if lookvector > hum.WalkSpeed then
    	lookvector = hum.WalkSpeed
    
    end
    if lookvector < -hum.WalkSpeed then
    	lookvector = -hum.WalkSpeed
    
    end
    if rightvector > hum.WalkSpeed then
    	rightvector = hum.WalkSpeed
    
    end
    if rightvector < -hum.WalkSpeed then
    	rightvector = -hum.WalkSpeed
    
    end

    lookvel = (lookvector / hum.WalkSpeed)/4
    rightvel = (rightvector / hum.WalkSpeed)/4
end

local swait do
    local stack = 0
    local step = run_service['RenderStepped']:wait()

    function swait(times)
        if times then
            local total = 0
            stack += times

            while stack >= step do
                step = run_service['RenderStepped']:wait()
                
                stack -= step
                total += step
            end
        else
            return run_service['RenderStepped']:wait()
        end
    end
end

animations['idle'] = function()
    local alpha = .1
    local speed = 18

	lerp('Neck',{0,0,0}, {0,0,0}, alpha)
	lerp('RJ' ,{0,0,0}, {0,0,0}, alpha)
	lerp('RS' ,{0,0,0}, {0,0,0}, alpha)
	lerp('LS' ,{0,0,0}, {0,0,0}, alpha)
	lerp('RH' ,{0,0,0}, {0,0,0}, alpha)
	lerp('LH' ,{0,0,0}, {0,0,0}, alpha)
end

animations['walking'] = function()
    local alpha = .1

	lerp('Neck',{0,0,0}, {0,0,0}, alpha)
	lerp('RJ' ,{0,0,0}, {0,,0}, alpha)
	lerp('RS' ,{0,0,0}, {0,0,0}, alpha)
	lerp('LS' ,{0,0,0}, {0,0,0}, alpha)
	lerp('RH' ,{0,0,0}, {0,0,0}, alpha)
	lerp('LH' ,{0,0,0}, {0,0,0}, alpha)
end

animations['jump'] = function()
    local alpha = .1

	lerp('Neck',{0,0,0}, {0,0,0}, alpha)
	lerp('RJ' ,{0,0,0}, {0,0,0}, alpha)
	lerp('RS' ,{0,0,0}, {0,0,0}, alpha)
	lerp('LS' ,{0,0,0}, {0,0,0}, alpha)
	lerp('RH' ,{0,0,0}, {0,0,0}, alpha)
	lerp('LH' ,{0,0,0}, {0,0,0}, alpha)
end

animations['fall'] = function()
    local alpha = .1

	lerp('Neck',{0,0,0}, {0,0,0}, alpha)
	lerp('RJ' ,{0,0,0}, {0,0,0}, alpha)
	lerp('RS' ,{0,0,0}, {0,0,0}, alpha)
	lerp('LS' ,{0,0,0}, {0,0,0}, alpha)
	lerp('RH' ,{0,0,0}, {0,0,0}, alpha)
	lerp('LH' ,{0,0,0}, {0,0,0}, alpha)
end

local function on_chatted(msg)
    msg = string.lower(msg)
    
    local split = string.split(msg ,' ')
    if commands[split[1]] then
        
    end
end

for _,v in pairs(char:GetDescendants()) do
    if v:IsA('Motor6D') then
        if C0s and C1s then
            motors[s_rename(v.Name)] = v

            v.C0 = C0s[v.Name]
            v.C1 = C1s[v.Name]
        else
            v:Destroy()
        end

        print('inserted: ' ..s_rename(v.Name) ..' --' ..v.Name)
    end
end

for _,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
	v:Stop()
end
char.Animate.Disabled = true

raycast_params = RaycastParams.new()
raycast_params.FilterDescendantsInstances = {char,workspace[char.Name]}
raycast_params.FilterType = Enum.RaycastFilterType.Blacklist

local music_player = IT.n('Sound')
music_player.Name = 'Animation Music'
music_player.SoundId = 'rbxassetid://'.. start_id
music_player.Volume = id_volume
music_player.Pitch = pitch
music_player.Looped = true
music_player.Parent = char
music_player:Play()

local bass = IT.n('EqualizerSoundEffect')
bass.HighGain= 0
bass.MidGain = 0
bass.LowGain = 0 --bass
bass.Enabled = false
bass.Parent = music_player

local reverb = IT.n('ReverbSoundEffect')
reverb.DryLevel = 0
reverb.Enabled = false
reverb.Parent = music_player

local echo = IT.n('EchoSoundEffect')
echo.Enabled = false
echo.Parent = music_player

if type(_G.loops_inst) == 'table' then
    for i=1,#_G.loops_inst do
        if type(_G.loops_inst[i]) == 'userdata' then
            _G.loops_inst[i]:Disconnect()
        else
            _G.loops_inst[i]:Destroy()
        end
    end
end

_G.loops_inst = {}

_G.loops_inst[#_G.loops_inst+1] =
run_service['RenderStepped']:Connect(function()
    swait(fps)
    local state = get_state()

    sine += 1
	get_rv_lv()

	animations[state]()
end)
