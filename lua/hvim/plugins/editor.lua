return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>pv", ":Neotree toggle<CR>", desc = "Toggle Neotree" },
		},
		opts = {
			enable_git_status = true,

			window = {
				position = "float",
			},

			default_component_configs = {
				indent = {
					with_expanders = true,
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
			},
		},

		config = function(_, opts)
			require("neo-tree").setup(opts)
			local oxc = require("oxocarbon").oxocarbon
			vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { fg = oxc.base02, bg = oxc.none })
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>pf",
				function()
					require("telescope.builtin").find_files()
				end,
				desc = "Find files",
			},
			{
				"<leader>ps",
				function()
					require("telescope.builtin").live_grep()
				end,
				desc = "Find files",
			},
			{
				"<leader><space>",
				function()
					require("telescope.builtin").buffers()
				end,
				desc = "Find files",
			},
		},
		opts = {
			defaults = {
				prompt_prefix = "   ",
				selection_caret = "  ",
				entry_prefix = "  ",
				sorting_strategy = "ascending",

				layout_strategy = "flex",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
					vertical = { mirror = false },
					width = 0.87,
					height = 0.8,
					preview_cutoff = 120,
				},

				dynamic_preview_title = true,

				set_env = {
					COLORTERM = "truecolor",
				},

				file_ignore_patterns = {
					"node_modules",
					".direnv",
					"venv",
					"vendor",
				},
			},
		},
		config = function(_, opts)
			require("telescope").setup(opts)
			local oxc = require("oxocarbon").oxocarbon

			vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = oxc.base03, bg = oxc.none })
			vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = oxc.base03, bg = oxc.none })
			vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = oxc.base05, bg = oxc.none })
			vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = oxc.base08, bg = oxc.none })
			vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = oxc.none, bg = oxc.none })
			vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = oxc.base12, bg = oxc.none })
			vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = oxc.base11, bg = oxc.none })
			vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = oxc.base14, bg = oxc.none })
			vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = oxc.none, bg = oxc.base01 })
			vim.api.nvim_set_hl(0, "TelescopePreviewLine", { fg = oxc.none, bg = oxc.none })
			vim.api.nvim_set_hl(0, "TelescopeMatching", {
				fg = oxc.base14,
				bg = oxc.none,
				bold = true,
				italic = true,
			})
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "LazyFile",
		dependencies = { "sindrets/diffview.nvim" },
		opts = function()
			local M = {
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				signs_staged = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
				},

				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, desc)
						vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
					end

					map("n", "<leader>cs", gs.stage_hunk, "Stage hunk")
					map("n", "<leader>cr", gs.reset_hunk, "Reset hunk")
					map("n", "<leader>cS", gs.stage_buffer, "Stage buffer")
					map("n", "<leader>cR", gs.reset_buffer, "Reset buffer")
					map("n", "<leader>cd", gs.diffthis, "Diff this")
					map("n", "]c", function()
						gs.nav_hunk("next")
					end, "Next hunk")
					map("n", "[c", function()
						gs.nav_hunk("prev")
					end, "Previous hunk")
				end,
			}

			Snacks.toggle({
				name = "Git Signs",
				get = function()
					return require("gitsigns.config").config.signcolumn
				end,
				set = function(state)
					require("gitsigns").toggle_signs(state)
				end,
			}):map("<leader>uG")

			return M
		end,

		config = function(_, opts)
			require("gitsigns").setup(opts)
			local oxc = require("oxocarbon").oxocarbon
			vim.api.nvim_set_hl(0, "DiffAdd", { fg = oxc.base13, bg = oxc.none })
			vim.api.nvim_set_hl(0, "DiffAdded", { fg = oxc.base13, bg = oxc.none })
			vim.api.nvim_set_hl(0, "DiffChange", { fg = oxc.base14, bg = oxc.none })
			vim.api.nvim_set_hl(0, "DiffChanged", { fg = oxc.base14, bg = oxc.none })
			vim.api.nvim_set_hl(0, "DiffDelete", { fg = oxc.base10, bg = oxc.none })
			vim.api.nvim_set_hl(0, "DiffRemoved", { fg = oxc.base10, bg = oxc.none })
			vim.api.nvim_set_hl(0, "DiffText", { fg = oxc.base02, bg = oxc.none })
		end,
	},
}
