payload
splitBy '\n'
map ($ splitBy /: +/)[1]
map ($ splitBy / +\| +/)
map ($ map ($ splitBy / +/))
map do {
    var got = $[0] map $ as Number
    var win = $[1] map $ as Number
    ---
    sizeOf(got filter (win contains $))
}
then do {
    var init = $
    var arr = init
        map { idx: $$, v: $ }
        reduce (v, acc=init map 1) -> do {
            var parts = acc dw::core::Arrays::splitAt (v.idx+1)
            var wins = parts.r dw::core::Arrays::splitAt v.v
            ---
            parts.l ++ (wins.l map ($ + acc[v.idx])) ++ wins.r
        }
    ---
    arr
}
then sum($)