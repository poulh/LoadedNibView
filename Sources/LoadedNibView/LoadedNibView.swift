import Cocoa

public protocol LoadedNibView: class {
    init(frame: NSRect)
    init?(coder aDecoder: NSCoder)
    
    var nibName : String { get }
    func load() -> Bool
    
    var view: NSView? { get set }
}


public extension LoadedNibView where Self: NSView {
    
    var nibName: String {
        return String(describing: Self.self)
    }

    func load() -> Bool {
        var nibObjects: NSArray?
        let nibName = NSNib.Name(stringLiteral: self.nibName)
        if Bundle.main.loadNibNamed(nibName, owner: self, topLevelObjects: &nibObjects) {
            guard let nibObjects = nibObjects else { return false }
            
            let viewObjects = nibObjects.filter { $0 is NSView }
            if viewObjects.count > 0 {
                guard let loadedView = viewObjects[0] as? NSView else { return false }
                view = loadedView
                self.addSubview(view!)
                
                view?.translatesAutoresizingMaskIntoConstraints = false
                if #available(OSX 10.11, *) {
                    view?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                    view?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                    view?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                    view?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                } else {
                    // Fallback on earlier versions
                }
                return true
            }
        }
        return false
    }
    
}
