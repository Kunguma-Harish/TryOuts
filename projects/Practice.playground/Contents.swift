public class ListNode {
    public var val: Int
    public var next: ListNode?
    
    public init() {
        self.val = 0
        self.next = nil
    }
    
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
    public init(_ val: Int, _ next: ListNode?) {
        self.val = val
        self.next = next
    }
}

func printLinkedList(list: ListNode?) {
    var head = list
    while let _head = head {
        print("Kungu : \(_head.val).")
        head = _head.next
    }
}

//func reverseList(_ head: ListNode?) -> ListNode? {
//    var cur = head
//    var prev: ListNode? = nil
//    while let _head = cur {
//        print("Kungu : rev - \(_head.val).")
//        prev = cur
//        cur = _head.next
//    }
//    return head
//}

var linkedList: ListNode? = ListNode(1)
linkedList?.next = ListNode(2)
linkedList?.next?.next = ListNode(6)
linkedList?.next?.next?.next = ListNode(3)
linkedList?.next?.next?.next?.next = ListNode(4)
linkedList?.next?.next?.next?.next?.next = ListNode(5)
linkedList?.next?.next?.next?.next?.next?.next = ListNode(6)

//printLinkedList(list: removeElements(linkedList, 6))
//printLinkedList(list: reverseList(linkedList))
printLinkedList(list: linkedList)

//func removeElements(_ head: ListNode?, _ val: Int) -> ListNode? {
//    var currentHead = head
//    var prevHead: ListNode? = nil
//
//    while let _head = currentHead {
//        if _head.val == val {
//            prevHead?.next = _head.next
//            print(_head.val)
//        }
//        prevHead = currentHead
//        currentHead = _head.next
//    }
//    return head
//}
