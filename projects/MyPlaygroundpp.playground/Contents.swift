import UIKit
var a = 0
var b = 9
var d = 0
var arr = [6,3,8,9,8,11,1,5,8,17]
while a != b+1 {
while (a+100) % 3 == 0 {
    d = arr[a] + arr[a+1]
    print("Kungu : ",d)
}
a = a + 1
}
