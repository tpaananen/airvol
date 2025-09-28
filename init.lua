local TARGET_VOLUME = 15        -- your desired target volume
local MAX_ATTEMPTS  = 10        -- number of times to retry to set the volume if the device reports other than desired volume
local RETRY_DELAY   = 0.2       -- retry delay in seconds
local DEVICE_NAME   = "airpods" -- matches by "contains" case insensitive

local lastDeviceName = ""

-- round the volume read from device, device returns volume as floating point number which may have typical "rounding issues"
local function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- set device volume to target volume or less if it initially reports less that the target level
local function setDeviceVolume(device, target)
    local actual = round(device:volume(), 0)
    if actual <= target then
        device:setVolume(actual)
        target = actual
    else
        device:setVolume(target)
    end

    return round(device:volume(), 0)
end

local function enforceVolume(attemptsLeft)
    local device = hs.audiodevice.defaultOutputDevice()
    if not device then
        print("Warning: defaultOutputDevice returned nil")
        return
    end

    local name = device:name()
    if not name then
        print("Warning: device name is nil")
        return
    end

    if not string.find(string.lower(name), DEVICE_NAME) then
        print("Device is not a target device: " .. name)
        return
    end

    local attempt = MAX_ATTEMPTS + 1 - attemptsLeft
    local volume = setDeviceVolume(device, TARGET_VOLUME)

    if volume <= TARGET_VOLUME then
        print("Success: volume locked at " .. volume .. " after " .. attempt .. " attempt(s)")
        hs.alert.show(name .. " connected, volume set to " .. volume)
        return
    end

    print("Attempt " .. attempt .. ": tried " .. TARGET_VOLUME .. ", actual " .. volume)

    if attemptsLeft > 1 then
        hs.timer.doAfter(RETRY_DELAY, function() enforceVolume(attemptsLeft - 1) end)
    else
        print("Final attempt done, volume is " .. volume)
        hs.alert.show(name .. " connected, volume targetting to " .. TARGET_VOLUME .. " did not succeed. Current volume " .. volume)
    end
end

function audioDeviceChanged()
    local current = hs.audiodevice.defaultOutputDevice()
    local name = current and current:name() or "nil"

    if name ~= lastDeviceName then
        lastDeviceName = name or ""
        print("Device changed: " .. tostring(name))
        if name and string.find(string.lower(name), DEVICE_NAME) then
            enforceVolume(MAX_ATTEMPTS)
        end
    end
end

hs.audiodevice.watcher.setCallback(audioDeviceChanged)
hs.audiodevice.watcher:start()
