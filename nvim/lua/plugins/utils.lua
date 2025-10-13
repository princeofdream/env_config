return {
    {
        "Civitasv/cmake-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim"},
        opts = {
            cmake_executable = "cmake", -- Path to cmake executable
            cmake_build_directory = "build", -- Path to build directory
            cmake_generate_options = {}, -- Extra options for cmake generation step
            cmake_build_options = {}, -- Extra options for cmake build step
            cmake_console_size = 10, -- Height of the CMake output window
            cmake_show_console = "always", -- When to show the CMake output window
            cmake_dap_configuration = { name = "Launch file", type = "codelldb", request = "launch" }, -- DAP configuration for debugging
            cmake_dap_open_command = function()
                require("dap").repl.open()
            end, -- Command to open the DAP repl window
        },
        config = function()
        end
    },
}

