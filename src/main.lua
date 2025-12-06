-- src/main.lua
local posix = require("posix")
local signal = require("posix.signal")

-- 7 rows x 11 columns (0-9 + ':')
local DIGITS = {
    {"┏━┓ ", "  ╻  ", " ┏━┓ ", " ┏━┓ ", " ╻ ╻ ", " ┏━┓ ", " ┏   ", " ┏━┓ ", " ┏━┓ ", " ┏━┓ ", "   "},
    {"┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ", " ┃ ┃ ", " ┃ ┃ ", " ╻ "},
    {"┃ ┃ ", "  ┃  ", "   ┃ ", "   ┃ ", " ┃ ┃ ", " ┃   ", " ┃   ", "   ┃ ", " ┃ ┃ ", " ┃ ┃ ", "   "},
    {"┃ ┃ ", "  ┃  ", " ┏━┛ ", " ┣━┫ ", " ┗━┫ ", " ┗━┓ ", " ┣━┓ ", "   ┃ ", " ┣━┫ ", " ┗━┫ ", "   "},
    {"┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", "   "},
    {"┃ ┃ ", "  ┃  ", " ┃   ", "   ┃ ", "   ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ┃ ┃ ", "   ┃ ", " ╹ "},
    {"┗━┛ ", "  ╹  ", " ┗━━ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ ", "   ╹ ", " ┗━┛ ", " ┗━┛ ", "   "},
}

-- number of rows we print each frame
local ROWS = #DIGITS

-- start: clear screen and hide cursor
io.write("\x1b[2J")   -- clear screen
io.write("\x1b[?25l") -- hide cursor
io.flush()

local function restore_and_exit(code)
    -- restore cursor and place newline
    io.write("\x1b[?25h\n")
    io.flush()
    os.exit(code or 0)
end

-- handle CTRL+C cleanly
signal.signal(signal.SIGINT, function()
    io.write("\nEncerrado pelo usuário.\n")
    restore_and_exit(0)
end)

local function draw_clock()
    local now = os.date("%H:%M:%S")
    for r = 1, ROWS do
        for ch in now:gmatch(".") do
            local col
            if ch >= "0" and ch <= "9" then
                col = tonumber(ch) + 1 -- 1..10
            else
                col = 11 -- ':' maps to index 11
            end
            io.write(DIGITS[r][col] .. " ")
        end
        io.write("\n")
    end
    io.flush()
end

-- main loop
while true do
    draw_clock()
    -- sleep 1 second (posix.nanosleep can be interrupted by SIGINT)
    posix.nanosleep(1)
    -- move cursor up exactly ROWS lines to overwrite previous frame
    io.write("\x1b[" .. ROWS .. "A")
    io.flush()
end