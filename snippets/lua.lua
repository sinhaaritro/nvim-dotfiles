local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local extras = require("luasnip.extras")
local rep = extras.rep

ls.add_snippets("lua", {
	s("nvim_snippet_text", {
		t('print("hello world")'),
	}),
})

ls.add_snippets("lua", {
	s("nvim_snippet_insert", {
		t('print("'),
		i(1),
		t('")'),
	}),
})

ls.add_snippets("lua", {
	s("nvim_snippet_jump", {
		t('print("'),
		i(1, "Hello"),
		t(" Seperator "),
		i(2, "World"),
		t(" Seperator "),
		i(3, ""),
		t(' ")'),
	}),
})

ls.add_snippets("lua", {
	s("beg", {
		t("\\begin{"),
		i(1),
		t("}"),
		t({ "", "\t" }),
		i(0),
		t({ "", "\\end{" }),
		rep(1),
		t("}"),
	}),
})

ls.add_snippets("lua", {
	s("nvim_snippet_choice", {
		t('print("'),
		c(1, {
			t("hello world"),
			t("Hello world"),
			t("Hello World"),
		}),
		t('")'),
	}),
})
