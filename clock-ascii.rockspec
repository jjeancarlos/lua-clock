package = "clock-ascii"
version = "0.1-1"
source = {
    url = "git+file://."
}

description = {
    summary = "Um relógio ASCII no terminal feito em Lua.",
    detailed = "Replica um relógio estilo seven-segment usando caracteres unicode.",
    homepage = "http://example.com", -- pode deixar assim
    license = "MIT"
}

dependencies = {
    "lua >= 5.3",
    "luaposix"
}

build = {
    type = "builtin",
    modules = {
        ["clock"] = "src/main.lua",
    }
}