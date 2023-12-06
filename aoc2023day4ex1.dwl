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
map (if ($ == 0) 0 else pow(2, $-1))
then sum($)