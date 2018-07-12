
import Foundation

public protocol JSONKeyRepresentable {
    var jsonKeyStringValue: String? { get }
    var jsonKeyNumberValue: Int? { get }
}

extension String: JSONKeyRepresentable {
    public var jsonKeyStringValue: String? { return self }
    public var jsonKeyNumberValue: Int? { return nil }
}
extension Int: JSONKeyRepresentable {
    public var jsonKeyStringValue: String? { return nil }
    public var jsonKeyNumberValue: Int? { return self }
}

public protocol DeepTraversable {
    func deepGet(_ path: JSONKeyRepresentable...) -> Any?
    func deepGet(_ path: [JSONKeyRepresentable]) -> Any?
    func deepNext(pathIndex: JSONKeyRepresentable) -> Any?
}

extension Array {
    mutating func popFront() -> Element? {
        if self.count == 0 { return nil }
        let value = self.remove(at: 0)
        return value
    }
}

//extension DeepTraversable {
//    public func deepGet(_ path: JSONKeyRepresentable...) -> Any? {
//        return self.deepGet(path)
//    }
//
//    public func deepGet(_ path: [JSONKeyRepresentable]) -> Any? {
//        var path = path
//
//        guard let p = path.popFront() else {
//            return nil
//        }
//
//        let next = deepNext(pathIndex: p)
//        if path.count == 0 {
//            return next
//        }
//        if let obj = next as? Dictionary<String, Any> {
//            return obj.deepGet(path)
//        }
//        if let arr = next as? Array<Any> {
//            return arr.deepGet(path)
//        }
//
//        return nil
//    }
//}

extension Dictionary where Key == String, Value == Any {
    
    public func deepGet(_ path: JSONKeyRepresentable...) -> Any? {
        return self.deepGet(path)
    }
    
    public func deepNext(pathIndex: JSONKeyRepresentable) -> Any? {
        guard let key = pathIndex.jsonKeyStringValue else {
            return nil
        }
        return self[key]
    }
    
    public func deepGet(_ path: [JSONKeyRepresentable]) -> Any? {
        var path = path
        
        guard let p = path.popFront() else {
            return nil
        }
        
        let next = deepNext(pathIndex: p)
        if path.count == 0 {
            return next
        }
        if let obj = next as? Dictionary<String, Any> {
            return obj.deepGet(path)
        }
        if let arr = next as? Array<Any> {
            return arr.deepGet(path)
        }
        
        return nil
    }
}

extension Array where Element == Any {
    
    public func deepGet(_ path: JSONKeyRepresentable...) -> Any? {
        return self.deepGet(path)
    }
    
    public func deepNext(pathIndex: JSONKeyRepresentable) -> Any? {
        guard let key = pathIndex.jsonKeyNumberValue else {
            return nil
        }
        guard self.count > key else {
            return nil
        }
        return self[key]
    }
    
    public func deepGet(_ path: [JSONKeyRepresentable]) -> Any? {
        var path = path
        
        guard let p = path.popFront() else {
            return nil
        }
        
        let next = deepNext(pathIndex: p)
        if path.count == 0 {
            return next
        }
        if let obj = next as? Dictionary<String, Any> {
            return obj.deepGet(path)
        }
        if let arr = next as? Array<Any> {
            return arr.deepGet(path)
        }
        
        return nil
    }
}
