function testing()
    local temp = require 'plenary.path'
    local scan = require 'plenary.scandir'
    local temp2 = scan.scan_dir('%', {hidden = true, depth = 2})
    printTable(temp)
    print('----')
    printTable(temp.path)
end

function printTable(T) for k, v in pairs(T) do print(k, v) end end

function scanTarget()
    local bfd = vim.fn.expand('%:p:h')
    local cwd = vim.fn.getcwd()
    local scan = require 'plenary.scandir'
    while string.sub(bfd, 1, string.len(cwd)) == cwd do
        local scanResult = scan.scan_dir(bfd, {depth = 2})
        idx = string.find(bfd, "/[^/]*$")
        bfd = string.sub(bfd, 1, idx - 1)
    end
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function getCurrentAstNodename()
    local parser = vim.treesitter.get_parser(0)
    local tstree = parser:parse()
    print(dump(tstree))
    print(tstree[1])
    local root = tstree[1]:root()
    print(root)
end

vim.api.nvim_set_keymap('n', '<Space>xd', ':lua getCurrentAstNodename()<CR>',
                        {noremap = true})

-- getCurrentAstNodename()
