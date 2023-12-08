%dw 2.5
fun repeat(init: String): Array<String> = do {
    @TailRec()
    fun rec(curr: String | Null): Array<String> =
        if (curr == null)
            rec(init)
        else
            [curr[0] ~ rec(curr[1 to -1])]
    ---
    rec(init)
}
var parts = payload
    replace '\r' with ''
    splitBy '\n\n'
var directions = repeat(parts[0])
var graph = parts[1]
    splitBy '\n'
    map ($ splitBy ' = ')
    map {
        ($[0]): $[1][1 to -2]
            splitBy ', '
            then { L: $[0], R: $[1]}
    }
    reduce ($ ++ $$)
@TailRec()
fun wander(
    directions: Array<String>,
    graph,
    curr: String,
    steps: Number
) =
    if (curr == 'ZZZ')
        steps
    else
        directions match {
            case [x ~ xs] ->
                wander(
                    xs,
                    graph,
                    graph[curr][x],
                    steps + 1)
        }
---
wander(directions, graph, 'AAA', 0)
