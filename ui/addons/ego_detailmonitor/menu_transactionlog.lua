-- param == { 0, 0, container }

-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef[[
	bool IsComponentOperational(UniverseID componentid);
	bool IsMouseEmulationActive(void);
	bool IsRealComponentClass(UniverseID componentid, const char* classname);
]]

local menu = {
	name = "TransactionLogMenu",
	lastRefreshTime = 0,
}

local config = {
	infoLayer = 4,
	contextLayer = 2,
	mouseOutRange = 100,
}

local function init()
	Menus = Menus or { }
	table.insert(Menus, menu)
	if Helper then
		Helper.registerMenu(menu)
	end
end

function menu.cleanup()
	menu.infoFrame = nil
	menu.sidebar = nil
	menu.topNavbar = nil
	menu.infoTable = nil

	menu.settoprow = nil
	menu.setselectedrow = nil
	menu.settoprowid = nil

	menu.selectedRows = {}
end

-- widget scripts

function menu.buttonRightBar(newmenu, params)
	Helper.closeMenuAndOpenNewMenu(menu, newmenu, params, true)
	menu.cleanup()
end

function menu.buttonContainerInfo(controllable)
	Helper.closeMenuAndOpenNewMenu(menu, "MapMenu", { 0, 0, true, nil, nil, "infomode", { "info", controllable } })
	menu.cleanup()
end

function menu.buttonTransactionLog(controllable)
	Helper.closeMenuAndOpenNewMenu(menu, "TransactionLogMenu", { 0, 0, controllable });
	menu.cleanup()
end

-- Menu member functions

function menu.onShowMenu()
	-- Init
	menu.containerid = menu.param[3]
	menu.container = ConvertIDTo64Bit(menu.containerid)

	menu.isstation = C.IsRealComponentClass(menu.container, "station")

	menu.selectedRows = {}

	-- display main frame
	menu.createFrame()
end

function menu.refreshInfoFrame(toprow, selectedrow)
	if menu.infoTable then
		menu.settoprow = toprow or GetTopRow(menu.infoTable)
		if menu.settoprow and Helper.transactionLogData then
			Helper.transactionLogData.topRowId = menu.rowDataMap[menu.infoTable] and menu.rowDataMap[menu.infoTable][menu.settoprow]
		end
		menu.setselectedrow = selectedrow or Helper.currentTableRow[menu.infoTable]
	end

	menu.createFrame()
end

function menu.createFrame()
	-- remove old data
	Helper.clearDataForRefresh(menu, config.infoLayer)

	local frameProperties = {
		layer = config.infoLayer,
		standardButtons = { back = true, close = true, help = true  },
		width = Helper.viewWidth,
		height = Helper.viewHeight,
		x = 0,
		y = 0,
	}
	menu.infoFrame = Helper.createFrameHandle(menu, frameProperties)
	menu.infoFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	menu.sidebarWidth = Helper.scaleX(Helper.sidebarWidth)

	if menu.isstation then
		local rightbartable = Helper.createRightSideBar(menu, menu.infoFrame, menu.container, true, "transactions", menu.buttonRightBar)
		rightbartable:addConnection(1, 4, true)
	end

	local tableProperties = {
		width = Helper.round(Helper.playerInfoConfig.width * 1.5),
		height = Helper.viewHeight - 2 * Helper.frameBorder,
		x = Helper.frameBorder,
		y = Helper.frameBorder,
		x2 = menu.isstation and (menu.sidebarWidth + Helper.borderSize + Helper.frameBorder) or Helper.frameBorder,
	}
	Helper.createTransactionLog(menu, menu.container, tableProperties, menu.refreshInfoFrame, 0)

	menu.infoFrame:display()
	menu.lastRefreshTime = getElapsedTime()
end

function menu.createContextFrame(data, x, y, width, nomouseout)
	Helper.removeAllWidgetScripts(menu, config.contextLayer)
	PlaySound("ui_positive_click")

	local contextmenuwidth = width or menu.contextMenuWidth

	menu.contextFrame = Helper.createFrameHandle(menu, {
		layer = config.contextLayer,
		standardButtons = { close = true },
		width = contextmenuwidth,
		x = x,
		y = 0,
		autoFrameHeight = true,
	})
	menu.contextFrame:setBackground("solid", { color = Color["frame_background_semitransparent"] })

	local ftable = menu.contextFrame:addTable(1, { tabOrder = 4, highlightMode = "off" })

	-- fill data
	Helper.createTransactionLogTableContext(menu, ftable, data)

	if menu.contextFrame.properties.x + contextmenuwidth > Helper.viewWidth then
		menu.contextFrame.properties.x = Helper.viewWidth - contextmenuwidth - Helper.frameBorder
	end
	local height = menu.contextFrame:getUsedHeight()
	if y + height > Helper.viewHeight then
		menu.contextFrame.properties.y = Helper.viewHeight - height - Helper.frameBorder
	else
		menu.contextFrame.properties.y = y
	end

	menu.contextFrame:display()

	if not nomouseout then
		menu.mouseOutBox = {
			x1 =   menu.contextFrame.properties.x -  Helper.viewWidth / 2                    - config.mouseOutRange,
			x2 =   menu.contextFrame.properties.x -  Helper.viewWidth / 2 + contextmenuwidth + config.mouseOutRange,
			y1 = - menu.contextFrame.properties.y + Helper.viewHeight / 2                    + config.mouseOutRange,
			y2 = - menu.contextFrame.properties.y + Helper.viewHeight / 2 - height           - config.mouseOutRange
		}
	end
end

function menu.viewCreated(layer, ...)
	if menu.isstation then
		menu.sidebar, menu.topNavbar, menu.infoTable = ...
	else
		menu.topNavbar, menu.infoTable = ...
	end
end

-- update
menu.updateInterval = 0.1

function menu.onUpdate()
	menu.infoFrame:update()

	if not Helper.transactionLogData.noupdate then
		local curtime = getElapsedTime()
		if curtime > menu.lastRefreshTime + 10 then
			menu.refreshInfoFrame()
		end
	end

	if Helper.transactionLogData and Helper.transactionLogData.graphUpdateSelection then
		Helper.updateTransactionLogGraphSelection()
		Helper.transactionLogData.graphUpdateSelection = false
	end

	if menu.mouseOutBox then
		if (GetControllerInfo() ~= "gamepad") or (C.IsMouseEmulationActive()) then
			local curpos = table.pack(GetLocalMousePosition())
			if curpos[1] and ((curpos[1] < menu.mouseOutBox.x1) or (curpos[1] > menu.mouseOutBox.x2)) then
				menu.closeContextMenu()
			elseif curpos[2] and ((curpos[2] > menu.mouseOutBox.y1) or (curpos[2] < menu.mouseOutBox.y2)) then
				menu.closeContextMenu()
			end
		end
	end
end

function menu.onRowChanged(row, rowdata, uitable)
	if uitable == menu.infoTable then
		Helper.onTransactionLogRowChanged(rowdata)
	end
end

function menu.onSelectElement(uitable, modified, row)
end

function menu.onEditBoxActivated(widget)
	Helper.onTransactionLogEditBoxActivated(widget)
end

function menu.onTableRightMouseClick(uitable, row, posx, posy)
	if uitable == menu.infoTable then
		Helper.onTransactionLogTableRightMouseClick(menu, uitable, row, posx, posy)
	end
end

function menu.closeContextMenu()
	Helper.clearFrame(menu, config.contextLayer)
	menu.contextMenuMode = nil
	menu.mouseOutBox = nil
end

function menu.onCloseElement(dueToClose)
	if dueToClose == "back" then
		if menu.contextMenuMode then
			menu.closeContextMenu()
			return
		end

		if Helper.checkDiscardStationEditorChanges(menu) then
			return
		end
	end

	Helper.closeMenu(menu, dueToClose)
	menu.cleanup()
end

init()
