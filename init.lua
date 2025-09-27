local TARGET_VOLUME = 15 -- set your target volume
local MAX_ATTEMPTS  = 10
local RETRY_DELAY   = 0.2
local DEVICE_NAME   = "airpods"

local lastDeviceName = ""

local function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function enforceVolume(attemptsLeft)
    local current = hs.audiodevice.defaultOutputDevice()
    if not current then
        print("Warning: defaultOutputDevice returned nil")
        return
    end

    local name = current:name()
    if not name then
        print("Warning: device name is nil")
        return
    end

    if not string.find(string.lower(name), DEVICE_NAME) then
        print("Device is not a target device: " .. name)
        return
    end

    current:setVolume(TARGET_VOLUME)
    local actual = round(current:volume(), 0)
    local max = MAX_ATTEMPTS + 1
    print("Attempt " .. (max - attemptsLeft) .. ": tried " .. TARGET_VOLUME .. ", actual " .. actual)

    if actual == TARGET_VOLUME then
        print("Success: volume locked at " .. actual .. " after " .. (max - attemptsLeft) .. " attempt(s)")
        hs.alert.show(name .. " connected, volume set to " .. TARGET_VOLUME)
        return
    end

    if attemptsLeft > 1 then
        hs.timer.doAfter(RETRY_DELAY, function() enforceVolume(attemptsLeft - 1) end)
    else
        print("Final attempt done, volume is " .. actual)
        hs.alert.show(name .. " connected, volume targetting to " .. TARGET_VOLUME .. " did not succeed. Current volume " .. actual)
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
