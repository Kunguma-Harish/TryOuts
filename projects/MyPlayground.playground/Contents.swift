import UIKit

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
}

func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
    guard let list1,
          let list2 else {
        return list1 ?? list2
    }

    if list1.val <= list2.val {
        list1.next = mergeTwoLists(list1.next, list2)
        return list1
    }
    list2.next = mergeTwoLists(list1, list2.next)
    return list2
}

let list1: ListNode = ListNode(1, ListNode(2, ListNode(4)))
let list2: ListNode = ListNode(1, ListNode(3, ListNode(4)))
let result = mergeTwoLists(list1, list2)
print(result)
