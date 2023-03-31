//
//  UIComponent.swift
//  
//
//  Created by Óscar Morales Vivó on 3/30/23.
//

#if canImport(UIKit)
import UIKit

/**
 A UIKit UIViewController that runs with a `Controller`.

 Make your view controllers inherit from this class as to take care of all the drudgery of setting up the controller and
 initializer song and dance.
 */
open class UIComponent<ID: Hashable, ModelProperty: ReadOnlyProperty, Persistence>: UIViewController {

    // MARK: - Types

    public typealias Controller = SwiftUX.Controller<ID, ModelProperty, Persistence>

    // MARK: - Initializers

    /**
     Nib & Bundle initializer.

     Some people, bless their hearts, still use `.xib` and `.storyboard` files. This initializer is for them, so they
     can build up their view controllers with an actual controller attached.

     This initializer is also for everyone else who builds the UI on code as it will default the parameters to nil
     so you can override `loadView` and/or `viewDidLoad` to do the work.
     - Parameter controller: The controller that is going to be held by the UI component.
     - Parameter nibName: To be passed up to the superview's initializer. Defaults to `nil`.
     - Parameter bundle: To be passed up to the superview's initializer. Defaults to `nil`.
     */
    init(controller: Controller, nibName: String? = nil, bundle: Bundle? = nil) {
        self.controller = controller
        super.init(nibName: nibName, bundle: bundle)
    }

    /**
     Decoding initializer not available for `UIComponent` and its subclasses.
     */
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Stored Properties

    public let controller: Controller
}
#endif
