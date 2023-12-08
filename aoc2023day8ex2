%dw 2.5
import every from dw::core::Arrays
var parts = payload
    replace '\r' with ''
    splitBy '\n\n'
var dir = parts[0]
var len = sizeOf(dir)
var graph: Object = parts[1]
    splitBy '\n'
    map ($ splitBy ' = ')
    map {
        ($[0]): $[1][1 to -2]
            splitBy ', '
            then { L: $[0], R: $[1]}
    }
    reduce (v, acc={}) -> v ++ acc
var idToName = namesOf(graph)
var nameToId = idToName map { ($): $$ } reduce (v, acc={}) -> v ++ acc
var isWinning = idToName map ($ endsWith 'Z')
var numGraph = idToName flatMap [nameToId[graph[$].L] as Number, nameToId[graph[$].R] as Number]
fun wander(init: String) = do {
    @TailRec()
    fun rec(step: Number, curr: Number) =
        if (isWinning[curr])
            step
        else
            dir[step mod len] match {
                case 'L' -> rec(step + 1, numGraph[curr * 2])
                case 'R' -> rec(step + 1, numGraph[curr * 2 + 1])
            }
    ---
    rec(0, nameToId[init] as Number)
}
@TailRec()
fun gcd(a: Number, b: Number): Number =
    if (b == 0)
        a
    else
        gcd(b, a mod b)
fun lcm(a: Number, b: Number): Number =
    (a*b)/gcd(a, b)
var initial = namesOf(graph) filter ($ endsWith 'A')
---
// NOTE: This is not a real solution to the problem
//
// This solution relies on an unspecified property of the input graph.
// The "ENDING WITH Z" property of a path always repeats with the same frequency.
initial
    map wander($)
    reduce (v, acc=1) -> lcm(v, acc)
