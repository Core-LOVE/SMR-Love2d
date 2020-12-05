local screenshotter = {}

-- TODO: most of this is love2d-depent. replace it later.

local function getName()
    local timeData = os.date("*t")

    return (
        timeData.year.. "-"..
        string.format("%.2d",timeData.month).. "-"..
        string.format("%.2d",timeData.day).. "-"..
        string.format("%.2d",timeData.hour).. "-"..
        string.format("%.2d",timeData.min).. "-"..
        string.format("%.2d",timeData.sec)
    )
end

function screenshotter.takeScreenshot()
    local name = getName()

    love.graphics.captureScreenshot(name.. ".png")
end

function screenshotter.update()

end

return screenshotter