local kittyPath = "/Applications/kitty.app/Contents/MacOS/kitty"
local homePath = os.getenv("HOME")

hs.hotkey.bind({"ctrl"}, "return", function()
    if hs.fs.attributes(kittyPath) then
        hs.task.new(kittyPath, nil, {"--directory", homePath}):start()
    else
        hs.alert.show("kitty no encontrado en: " .. kittyPath)
    end
end)
