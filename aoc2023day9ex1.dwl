import * from dw::core::Arrays
var lines = payload
    replace '\r' with ''
    splitBy '\n'
    map ($ splitBy ' ' map $ as Number)
fun step(v: Array<Number>): Array<Number> =
    zip(v[0 to -2], v[1 to -1])
    map ($[1] - $[0])
fun doReduction(v: Array<Number>, acc: Number = 0): Number = do {
    var next = step(v)
    ---
    if (next every $ == 0)
        acc + v[-1]
    else
        doReduction(next, acc + v[-1])
}
---
lines sumBy doReduction($)
