import * from dw::core::Strings
import * from dw::core::Arrays
type Span = { start: Number, end: Number }
var groups = payload
    replace '\r' with ''
    splitBy '\n\n'
var seeds = groups[0]
    substringAfterLast ': '
    splitBy ' '
    map ($ as Number)
    divideBy 2
    map { start: $[0], end: $[0]+$[1]-1 }
var maps = groups[1 to -1]
    map (
        $
        substringAfter '\n'
        splitBy '\n'
        map (
            $ splitBy ' '
            map ($ as Number))
        map {
            start: $[1],
            end: $[1] + $[2] - 1,
            remapStart: $[0],
            remapEnd: $[0] + $[2] - 1
        }
        map (
            (g) ->
                (n: Span, cont: (Span) -> Array<Span>) -> do {
                    var intersect = {
                        start: max([g.start, n.start]),
                        end: min([g.end, n.end])
                    }
                    var pre = {
                        start: n.start,
                        end: intersect.start - 1
                    }
                    var newSpan = {
                        start: intersect.start - g.start + g.remapStart,
                        end: intersect.end - g.start + g.remapStart
                    }
                    var post = {
                        start: intersect.end + 1,
                        end: n.end
                    }
                    ---
                    if (intersect.start <= intersect.end)
                        [newSpan]
                        ++ (if (pre.start <= pre.end) cont(pre) else [])
                        ++ (if (post.start <= post.end) cont(post) else [])
                    else
                        cont(n)
                })
        reduce (
            (v, acc=(n: Span) -> [n]) ->
                (n: Span) ->
                    v(n, acc)))
---
maps
reduce ((v, acc=seeds) ->
    acc
        flatMap v($)
        orderBy $.start)
minBy $.start