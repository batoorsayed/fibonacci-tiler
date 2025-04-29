-- fibonacci-layout.lua - Main script for Fibonacci window layout
-- Path: ~/.config/devilspie2/fibonacci-layout.lua

-- Helper function to calculate height based on Fibonacci sequence
function calculate_fibonacci_height(position, total, available_height)
    -- Use golden ratio to determine sizes
    local golden_ratio = 0.618
    local height_ratio = math.pow(golden_ratio, position)
    
    -- Ensure all windows get at least some space
    local total_ratio = 0
    for i=1, total do
        total_ratio = total_ratio + math.pow(golden_ratio, i)
    end
    
    -- Calculate height with minimum size
    local min_height = 100
    local height = math.max(min_height, math.floor((available_height * height_ratio / total_ratio) - GAP))
    
    return height
end

-- Helper function to calculate vertical position
function calculate_fibonacci_offset(position, total, available_height)
    -- Calculate offset based on heights of previous windows
    local offset = 0
    for i=1, position-1 do
        offset = offset + calculate_fibonacci_height(i, total, available_height) + GAP
    end
    
    return offset
end

-- TODO: Make MAIN_RATIO, MARGIN, GAP configurable
-- Configuration
local MAIN_RATIO = 0.65  -- Main window takes 65% of width
local MARGIN = 10        -- Margin from screen edges
local GAP = 5            -- Gap between windows

-- Get screen dimensions
local screen_geometry = get_screen_geometry()
local screen_width = screen_geometry[3]
local screen_height = screen_geometry[4]

-- TODO: Find reliable way to get the geometry of the *monitor* containing the window
-- Multi-monitor Setup

-- Get current window info
local window_xid = get_window_xid()
local window_workspace = get_window_workspace()
local window_class = get_window_class()
-- local app_name = get_application_name()
-- local window_name = get_window_name()

-- Skip certain windows
if get_window_type() ~= "WINDOW_TYPE_NORMAL" or
   string.match(window_class, "Cinnamon") or
   string.match(window_class, "Nemo-desktop") then
   return
end

-- TODO: Handle minimized/restored windows more gracefully (see proposed_minimization_handling)

-- Check if layout is enabled for this workspace
local enabled = false
local workspace_enabled_file = os.getenv("HOME") .. "/.local/share/fibonacci-layout/workspace_" .. window_workspace .. "_enabled"
local f = io.open(workspace_enabled_file, "r")
if f then
    enabled = true
    f:close()
else
    return
end


-- If layout is not enabled, do nothing
-- if not enabled then
--    return
-- end

-- Get list of windows on this workspace
local windows_file = os.getenv("HOME") .. "/.local/share/fibonacci-layout/workspace_" .. window_workspace .. "_windows"
local windows = {}
-- local main_window = nil

-- Read existing windows data
local f = io.open(windows_file, "r")
if f then
    for line in f:lines() do
        local id = tonumber(line)
        if id then
            -- if not main_window then
            --     main_window = id
            -- end
            table.insert(windows, id)
        end
    end
    f:close()
end
-- TODO: Only write window list file if changes occurred (added/removed window)

-- Add current window to list if not already there
local is_new_window = true
for _, id in ipairs(windows) do
    if id == window_xid then
        is_new_window = false
        break
    end
end

if is_new_window then
    -- Make this the main window and move others to sub area
    -- main_window = window_xid
    table.insert(windows, 1, window_xid)
    
    -- Save updated window list
    local f = io.open(windows_file, "w")
    if f then
        for _, id in ipairs(windows) do
            f:write(tostring(id) .. "\n")
        end
        f:close()
    end
end

-- Calculate window layout
if #windows == 1 then
    -- Only one window - it goes in the main area
    set_window_geometry(MARGIN, MARGIN, screen_width - (2 * MARGIN), screen_height - (2 * MARGIN))
else
    -- Multiple windows - implement Fibonacci layout
    local main_width = math.floor((screen_width - (3 * MARGIN)) * MAIN_RATIO)
    local sub_width = screen_width - main_width - (3 * MARGIN)
    
    -- Position each window
    for i, id in ipairs(windows) do
        if id == window_xid then
            if i == 1 then
                -- This is the main window
                set_window_geometry(MARGIN, MARGIN, main_width, screen_height - (2 * MARGIN))
            else
                -- This is a sub window - calculate Fibonacci position
                local total_subs = #windows - 1
                local position = i - 1
                local sub_height = calculate_fibonacci_height(position, total_subs, screen_height - (2 * MARGIN))
                local top_offset = calculate_fibonacci_offset(position, total_subs, screen_height - (2 * MARGIN))
                
                set_window_geometry(main_width + (2 * MARGIN), MARGIN + top_offset, 
                                   sub_width, sub_height)
            end
            break
        end
    end
end

