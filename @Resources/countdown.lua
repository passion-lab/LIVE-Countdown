
PROPERTIES = {year=0, month=0, day=0, hour=0, min=0, sec=0, uptxt=""}

function Initialize()

	RELEASEDATE = {}
	setmetatable(RELEASEDATE, getmetatable(PROPERTIES))
	for k,v in pairs(PROPERTIES) do
		if k ~= uptxt then
			RELEASEDATE[k] = v
		end
	end
	RELEASEDATE.isdst = true

	RELEASETEXT = PROPERTIES.uptxt or "Time Up!"

end

function GetTimeLeft()
	local dif = os.time(RELEASEDATE) - os.time()
	local timeleft = {
		[1] = math.floor(dif / 60 / 60 / 24),	--day
		[2] = math.floor(dif / 60 / 60) % 24,	--hour
		[3] = math.floor(dif / 60) % 60,		--minute
		[4] = math.floor(dif) % 60				--second
	}

	-- Helps to blink the [LiveDot]
	if timeleft[4] % 2 == 0 then
		SKIN:Bang('!SetOption', 'LiveDot', 'Shape', 'Ellipse 5,5,5,5 | StrokeWidth 0 | Fill Color #RedColor#')
		SKIN:Bang('!UpdateMeter', 'LiveDot')
		SKIN:Bang('!Redraw')
	else
		SKIN:Bang('!SetOption', 'LiveDot', 'Shape', 'Ellipse 5,5,5,5 | StrokeWidth 0 | Fill Color #GrayColor#')
		SKIN:Bang('!UpdateMeter', 'LiveDot')
		SKIN:Bang('!Redraw')
	end

	local hms_txt = {}
	local d_txt = ""
	for i=1, #timeleft do
		-- For the Day
		if i == 1 then
			if timeleft[i] > 0 then
				d_txt = tostring(timeleft[i]) .. "d."
			end
		-- For others
		else
			if timeleft[i] < 10 then
				-- Adds leading 0 if hour, minute, second is less than 10 ...
				table.insert(hms_txt, "0" .. tostring(timeleft[i]))
			else
				-- else, update as it is.
				table.insert(hms_txt, timeleft[i])
			end
		end
	end

	if dif <= 0 then
		hms_txt = RELEASETEXT
	else
		hms_txt = table.concat(hms_txt, ":")
	end

	return d_txt .. tostring(hms_txt)
end

function Update()
end

function GetStringValue()

	return GetTimeLeft()

end