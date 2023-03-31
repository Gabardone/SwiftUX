//
//  UIComponent.swift
//
//
//  Created by Óscar Morales Vivó on 3/30/23.
//

#if canImport(UIKit)
import Combine
import UIKit

/**
 A UIKit UIViewController that runs with a `Controller`.

 Make your view controllers inherit from this class as to take care of all the drudgery of setting up the controller and
 initializer song and dance.

 You can use something other than a `SwiftUX.Controller` to instantiate a concrete type out of this generic one but
 you'll miss on some of the benefits.
 */
open class UIComponent<Controller>: UIViewController where Controller: ControllerProtocol {
    // MARK: - Types

    public typealias Controller = Controller

    // MARK: - Initializers

    /**
     Nib & Bundle initializer.

     Some people, bless their hearts, still use `.xib` and `.storyboard` files. This initializer is for them, so they
     can build up their view controllers using the interface file and with an actual controller attached.

     This initializer is also for everyone else who builds the UI on code as it will default the parameters to nil
     after which you can override `loadView` and/or `viewDidLoad` to do the work.
     - Parameter controller: The controller that is going to be held by the UI component.
     - Parameter nibName: To be passed up to the superview's initializer. Defaults to `nil`.
     - Parameter bundle: To be passed up to the superview's initializer. Defaults to `nil`.
     */
    public init(controller: Controller, nibName: String? = nil, bundle: Bundle? = nil) {
        self.controller = controller
        super.init(nibName: nibName, bundle: bundle)
    }

    /**
     Decoding initializer not available for `UIComponent` and its subclasses.
     */
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Stored Properties

    public let controller: Controller

    private var controllerUpdateSubscription: (any Cancellable)?

    // MARK: - UIViewController Overrides

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Set up any UI left (even if this was loaded from .xib we probably need to tie up a few things).
        setupUI()

        // Get all the UI up to date before starting subscriptions as to avoid bouncebacks and weirdness.
        updateUI(modelValue: controller.modelProperty.value)

        // Initiate subscription to controller model's updates.
        controllerUpdateSubscription = controller.modelProperty.updates.sink { [weak self] newValue in
            self?.updateUI(modelValue: newValue)
        }
    }

    // MARK: - Abstract methods to override.

    /**
     Common funnel method for setting up the UI managed by the `UIComponent`

     This abstract method is separate from `viewDidLoad` so this class' override of the `UIViewController` method can
     enforce the order in which UI is set up and the subscription to the controller model updates is started.

     There is no need to call `super` when overriding this method.
     */
    open func setupUI() {
        // This method intentionally left blank.
    }

    /**
     Updates the UI component's managed UI based on the new value for its controller's model.

     This method is the funnel for getting the UI up to date with the controller's model value. If the implementation
     gets too unwieldy you should probably think of decomposing your view controller into subcomponents.

     Don't call `super`, this is a pure abstract method. Even if your view controller is purely static you should
     provide an implementation override to run during UI initialization.
     - Warning: At the time of this call `controller.model` may not be up to date with `newValue` yet, although
     `modelProperty.value` should already contain `newValue` per the API contract of `ReadOnlyProperty`. Either way you
     shouldn't depend on access to either of those for the implementation of this method.
     - Parameter modelValue: The new value for the controller's model.
     */
    open func updateUI(modelValue _: Controller.ModelProperty.Value) {
        // This method intentionally left boom.
        preconditionFailure("UIComponent.updateUI(modelValue:) is expected to be overridden.")
    }
}
#endif
