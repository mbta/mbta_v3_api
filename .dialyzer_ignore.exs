# .dialyzer_ignore.exs
[
  {"lib/mbta_v3_api/stops/api.ex", :call_without_opaque, 445},
  {"deps/httpoison/lib/httpoison/base.ex"},
  {"lib/mbta_v3_api.ex"}
]
