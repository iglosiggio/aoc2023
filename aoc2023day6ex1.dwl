import * from dw::core::Strings
type Race = { time: Number, dist: Number }
fun amounts(r: Race) = do {
    // We have a deg two polynomial
    // r.dist+1 = time_holding * time_moving
    // r.dist+1 = time_holding * (r.time - time_holding)
    // 0 = time_holding * (r.time - time_holding) + -r.dist-1
    // 0 = -time_holding**2 + r.time*time_holding + -r.dist-1
    var a = -1
    var b = r.time
    var c = -(r.dist+1)
    ---
    {
        min: ceil((-b - sqrt(b*b - 4*a*c)) / (2*a)),
        max: floor((-b + sqrt(b*b - 4*a*c)) / (2*a))
    }
}

---
payload
    splitBy '\n'
    map trim($ substringAfter ':')
    map ($ splitBy / +/)
    then zip($[0], $[1])
    map { time: $[0] as Number, dist: $[1] as Number }
    map amounts($)
    map $.max - $.min + 1
    reduce (v, acc=1) -> v * acc