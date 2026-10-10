-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	typedef uint64_t UniverseID;
]]

---------------------------------------------------------------------------------
-- Global view helper
---------------------------------------------------------------------------------

View = {
	currentFrames = 0,
	maxFrames = 5,
	menus = {},
	frames = {},
	viewDescriptor = nil,
	displayView = nil,
	updateMenu = nil,
	closeFrames = nil,
	hideView = nil
}

-- forward declarations of local functions
local onUpdate								-- callback, delegates to onUpdateHandler

local function init()
	SetScript("onUpdate", onUpdate)
end

function onUpdate()
	if View.viewDescriptor then
		ReleaseViewDescriptor(View.viewDescriptor)
		View.viewDescriptor = nil
	end
end

function View.createView()
	View.viewDescriptor = CreateView(View.generateFrameDescriptors(), View.isExclusiveInteractions(), View.isCloseOnUnhandledClick(), View.useMiniWidgetSystem(), View.startAnimation(), View.keepHUDVisible(), View.keepCrosshairVisible(), View.showTickerPermanently(), View.blurBackground(), View.usePanelMode())
	local frames = table.pack(DisplayView(View.viewDescriptor, View.isSurpressDisplayErrors(), View.hasPlayerControls()))
	local i = 1
	for _, menu in ipairs(View.menus) do
		menu.frames = {}
		for layer in pairs(menu.framedescriptors) do
			View.frames[layer] = frames[i]
			table.insert(menu.frames, frames[i])
			i = i + 1
		end
	end

	for _, menu in ipairs(View.menus) do
		if menu.callback then
			menu.callback(menu.frames)
		end
	end
end

function View.updateMenu(menu)
	menu.frames = {}
	menu.layers = {}
	local index = 0
	for layer, framedesc in pairs(menu.framedescriptors) do
		local frame = UpdateFrame(framedesc, menu.properties.surpressDisplayErrors, View.hasPlayerControls(), View.useMiniWidgetSystem(), View.startAnimation(), View.keepHUDVisible(), View.keepCrosshairVisible(), View.showTickerPermanently(), View.blurBackground(), View.usePanelMode())
		index = index + 1
		local indexbuffer = index
		menu.layers[layer] = indexbuffer
		View.frames[layer] = frame
		table.insert(menu.frames, frame)
	end
	menu.callback(menu.frames)
end

function View.hideFrame(frame)
	CloseFrame(frame, View.hasPlayerControls(), View.startAnimation(), View.useMiniWidgetSystem(), View.keepHUDVisible(), View.keepCrosshairVisible(), View.showTickerPermanently(), View.blurBackground(), View.usePanelMode())
	for layer, viewframe in pairs(View.frames) do
		if viewframe == frame then
			View.frames[layer] = nil
			break
		end
	end
end

function View.hideView()
	HideView()
	View.frames = {}
end

-- properties = {
--	["exclusiveInteractions"]
--	["closeOnUnhandledClick"]
--	["surpressDisplayErrors"]
--	["playerControls"]
--	["useMiniWidgetSystem"]
--	["startAnimation"]
--	["blurBackground"]
--	["keepHUDVisible"]
--	["keepCrosshairVisible"]
--	["showTickerPermanently"]
--	["panelMode"]
-- }
function View.registerMenu(id, type, callback, clearCallback, framedescriptors, menuname, properties)
	local numframes = 0
	for layer in pairs(framedescriptors) do
		numframes = numframes + 1
	end

	-- calculate the number of replaced frames before checking the frame limit 
	-- We don't want to start discarding the replaced frames and then notice we are over the limit though
	local numReplacedFrames = 0
	for i, menu in ipairs(View.menus) do
		if menu.id == id then
			numReplacedFrames = menu.numframes
		end
	end
	if numframes + View.currentFrames - numReplacedFrames > View.maxFrames then
		DebugError("View helper error. Requested menu '" .. id .. "' uses more frames than available.")
		return
	end

	local menuentry
	for i, menu in ipairs(View.menus) do
		if menu.id == id then
			View.currentFrames = View.currentFrames - menu.numframes + numframes
			for layer, framedesc in pairs(menu.framedescriptors) do
				ReleaseDescriptor(framedesc)
				if not framedescriptors[layer] then
					View.hideFrame(menu.frames[menu.layers[layer]])
				end
			end
			View.menus[i] = {
				id = id,
				type = type,
				callback = callback,
				clearCallback = clearCallback,
				numframes = numframes,
				framedescriptors = framedescriptors,
				layers = {},
				frames = {},
				name = menuname,
				properties = properties,
			}
			menuentry = View.menus[i]
			break
		end
	end
	if not menuentry then
		table.insert(View.menus, {
			id = id,
			type = type,
			callback = callback,
			clearCallback = clearCallback,
			numframes = numframes,
			framedescriptors = framedescriptors,
			layers = {},
			frames = {},
			name = menuname,
			properties = properties,
		})
		menuentry = View.menus[#View.menus]
		View.currentFrames = View.currentFrames + numframes
	end

	if not next(View.frames) then
		View.createView()
	else
		View.updateMenu(menuentry)
	end
end

function View.hasMenu(types)
	local menus = {}
	for i, menu in ipairs(View.menus) do
		menus[i] = menu
	end
	for i, menu in ipairs(menus) do
		if types[menu.type] then
			return true
		end
	end
	return false
end

function View.getMenu(types)
	for i, menu in ipairs(View.menus) do
		if types[menu.type] then
			return menu.name
		end
	end
end

function View.clearMenus(types)
	local menus = {}
	for i, menu in ipairs(View.menus) do
		menus[i] = menu
	end
	for i, menu in ipairs(menus) do
		if types[menu.type] then
			-- stop retriggering callback for menus from the same type
			types[menu.type] = nil
			menu.clearCallback()
		end
	end
end

function View.unregisterMenu(id, releaseFrameDescriptor)
	local closeFrames = {}
	for i, menu in ipairs(View.menus) do
		if menu.id == id then
			View.currentFrames = View.currentFrames - menu.numframes
			if releaseFrameDescriptor ~= false then
				for _, framedesc in pairs(menu.framedescriptors) do
					ReleaseDescriptor(framedesc)
				end
			end
			closeFrames = menu.frames
			table.remove(View.menus, i)
			break
		end
	end

	if View.currentFrames == 0 then
		View.hideView()
	else
		for _, frame in ipairs(closeFrames) do
			View.hideFrame(frame)
		end
	end
end

function View.minimizeMenu(id, text)
	local minimizeFrames = {}
	for i, menu in ipairs(View.menus) do
		if menu.id == id then
			minimizeFrames = menu.frames
			View.menus[i].minimized = true
			break
		end
	end

	for _, frame in ipairs(minimizeFrames) do
		View.minimizeFrame(frame, text)
	end
end

function View.restoreMenu(id)
	local restoreFrames = {}
	for i, menu in ipairs(View.menus) do
		if menu.id == id then
			restoreFrames = menu.frames
			View.menus[i].minimized = nil
			break
		end
	end

	for _, frame in ipairs(restoreFrames) do
		View.restoreFrame(frame)
	end
end

function View.minimizeFrame(frame, text)
	MinimizeFrame(frame, text, View.hasPlayerControls())
end

function View.restoreFrame(frame)
	RestoreFrame(frame, View.hasPlayerControls())
end

function View.generateFrameDescriptors()
	local framedescriptors = {}

	for _, menu in ipairs(View.menus) do
		local index = 0
		for layer, framedesc in pairs(menu.framedescriptors) do
			index = index + 1
			local indexbuffer = index
			menu.layers[layer] = indexbuffer
			table.insert(framedescriptors, framedesc)
		end
	end

	return framedescriptors
end

function View.isExclusiveInteractions()
	for _, menu in ipairs(View.menus) do
		if menu.properties.exclusiveInteractions then
			return true
		end
	end

	return false
end

function View.isCloseOnUnhandledClick()
	for _, menu in ipairs(View.menus) do
		if menu.properties.closeOnUnhandledClick then
			return true
		end
	end

	return false
end

function View.isSurpressDisplayErrors()
	for _, menu in ipairs(View.menus) do
		if not menu.properties.surpressDisplayErrors then
			return false
		end
	end

	return true
end

function View.hasPlayerControls()
	for _, menu in ipairs(View.menus) do
		if (not menu.properties.playerControls) and (not menu.minimized) then
			return false
		end
	end

	return true
end

function View.useMiniWidgetSystem()
	if #View.menus > 1 then
		return false
	end
	for _, menu in ipairs(View.menus) do
		if not menu.properties.useMiniWidgetSystem then
			return false
		end
	end

	return true
end

function View.startAnimation()
	for _, menu in ipairs(View.menus) do
		if menu.properties.startAnimation then
			return true
		end
	end
	
	return false
end

function View.blurBackground()
	for _, menu in ipairs(View.menus) do
		if menu.properties.blurBackground then
			return true
		end
	end

	return false
end

function View.keepHUDVisible()
	for _, menu in ipairs(View.menus) do
		if not menu.properties.keepHUDVisible then
			return false
		end
	end
	
	return true
end

function View.keepCrosshairVisible()
	for _, menu in ipairs(View.menus) do
		if not menu.properties.keepCrosshairVisible then
			return false
		end
	end
	
	return View.keepHUDVisible()
end

function View.showTickerPermanently()
	for _, menu in ipairs(View.menus) do
		if not menu.properties.showTickerPermanently then
			return false
		end
	end
	
	return true
end

function View.usePanelMode()
	for _, menu in ipairs(View.menus) do
		if menu.properties.panelMode then
			return true
		end
	end
	
	return false
end

---------------------------------------------------------------------------------
-- Init
---------------------------------------------------------------------------------

init()
