import Foundation



// MARK:- Dictionary Mapper

open class Mapper<T>: Object {
    
    private var json: Dictionary<string, any>?, currentValue: any?
    
    public init(JSON: Dictionary<string, any>) {
        self.json = JSON
        super.init()
        mapping(mapper: self)
    }
    
    public override init() {
        super.init()
    }
    
    private init(currentVal: any) {
        self.currentValue = currentVal
    }

    // MARK: -  subscript
    
    open subscript(key: string)-> Mapper? {
        return Mapper(currentVal: json?[key] as any)
    }
    
    // MARK: - computed properties
    
    final public var string: string? {
        return currentValue as? string
    }
    
    final public var integer: int? {
        return currentValue as? int
    }
    
    final public var dictionary: Dictionary<string, any>? {
        return currentValue as? Dictionary<string, any>
    }
    
    final public var dictionaries: Array<Dictionary<string, any>>? {
        return currentValue as? Array<Dictionary<string, any>>
    }
    
    final public var array: Array<T>? {
        return currentValue as? Array<T>
    }
    
    final public var boolean: bool? {
        return currentValue as? bool
    }
    
    // MARK: -  Functions
    
    open func mapping(mapper: Mapper) -> void { }
    
    
}

















