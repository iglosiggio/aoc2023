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
map ($.red default 0) * ($.green default 0) * ($.blue default 0)
then sum($)