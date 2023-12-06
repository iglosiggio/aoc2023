import * from dw::core::Strings
var groups = payload
    replace '\r' with ''
    splitBy '\n\n'
var seeds = groups[0]
    substringAfterLast ': '
    splitBy ' '
    map ($ as Number)
var maps = groups[1 to -1]
    map (
        $
        substringAfter '\n'
        splitBy '\n'
        map (
            $ splitBy ' '
            map ($ as Number))
        map (
            (group) ->
                (n: Number, cont: (Number) -> Number) ->
                    if (group[1] <= n and n < group[1] + group[2])
                        n - group[1] + group[0]
                    else
                        cont(n))
        reduce (
            (v, acc=(n: Number) -> n) ->
                (n: Number) ->
                    v(n, acc))
    )
---
maps
reduce ((v, acc=seeds) ->
    acc map v($))
minBy $