%dw 2.5
fun strength(card: String): Number = {
    A:  12, K:  11, Q:  10, J:   9, T:   8,
    "9": 7, "8": 6, "7": 5, "6": 4, "5": 3,
    "4": 2, "3": 1, "2": 0
}[card] default ???

fun handNumber(hand: String): Number =
    (0 to sizeOf(hand)-1) as Array<Number>
    reduce (v, acc=0) -> acc*13 + strength(hand[v])

fun level(hand: String): Number =
    (0 to sizeOf(hand)-1) as Array
    map hand[$]
    groupBy $
    mapObject ({ ($$): sizeOf($) })
    then (hand) -> sizeOf(hand) match {
        case 1 -> 13*13*13*13 // Five of a kind
        case 2 -> (max(valuesOf(hand)) default ???) * 13*13*13 // Four of a kind / Full house
        case 3 -> (max(valuesOf(hand)) default ???) * 13*13 // Three of a kind / Two pair
        case 4 -> 13 // One pair
        case 5 -> 0 // High card
    }

var hands = payload
    replace /\r/ with ''
    splitBy '\n'
    map ($ splitBy ' ' then { hand: $[0], bid: $[1] as Number })
    map ($ ++ { level: level($.hand) })
---
hands
orderBy level($.hand)*13*13*13*13*13+handNumber($.hand)
map $.bid*($$+1)
then sum($)
