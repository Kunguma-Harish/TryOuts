import UIKit

func tryOut() {
    var nums = [0, 0, 1, 1, 1, 2, 2, 3, 3, 4]
    var index = 0
    for num in nums where num != nums[index] {
        index += 1
        print("Kungu : \(index) -- \(num)")
        nums[index] = num
        print("Kungu : \(nums) ")
    }
}

tryOut()
