payload
splitBy '\n'
map ($ splitBy ': ')[1]
map do {
    ($ splitBy '; ')
    flatMap do {
        ($ splitBy ', ')
        map ($ splitBy ' '
            then { color: $[1], count: $[0] as Number })
    }
    groupBy $.color
    mapObject {
        ($.color[0]): ($.count maxBy $)
    }
}
map { index: $$ + 1, ($) }
filter (
    ($.red default 0) <= 12
    and ($.green default 0) <= 13
    and ($.blue default 0) <= 14
)
map $.index
then sum($)