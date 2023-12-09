import * from dw::core::Arrays
var lines = payload
    replace '\r' with ''
    splitBy '\n'
    map ($ splitBy ' ' map $ as Number)
fun step(v: Array<Number>): Array<Number> =
    zip(v[0 to -2], v[1 to -1])
    map ($[1] - $[0])
fun doReduction(v: Array<Number>): Number = do {
    if (v every $ == 0)
        0
    else
        v[0] - doReduction(step(v))
}
---
lines sumBy doReduction($)
