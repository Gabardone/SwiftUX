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

 The view controller will make sure to set itself up properly with the given controller, including initializing UI,
 state and subscriptions in the right order as to avoid initialization glitches.
 */
open class UIComponent<Controller>: UIViewController where Controller: ControllerProtocol {
    // MARK: - Types

    /**
     The controller type managed by this `UIComponent`.
     */
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
     Decoding initializer not currently available for `UIComponent` and its subclasses.
     */
    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Stored Properties

    /**
     The UI component's controller. No `protected` in Swift so everyone gets to look at it.
     */
    public let controller: Controller

    private var controllerUpdateSubscription: (any Cancellable)?

    // MARK: - UIViewController Overrides

    /**
     Orderly initialization override.

     The override in UIComponent ensures that initialization happens in the right order. Specifically:
     1. Calls `setUpUI` to ensure common UI components are initialized.
     2. Calls `updateUI` with the current controller model value as to set up the UI state accordingly.
     3. Starts the subscription to the controller model updates.
     */
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Set up any UI left (even if this was loaded from .xib we probably need to tie up a few things).
        setUpUI()

        // Get all the UI up to date before starting subscriptions as to avoid bouncebacks and weirdness.
        updateUI(modelValue: controller.model.value)

        // Initiate subscription to controller model's updates.
        controllerUpdateSubscription = controller.model.updates.sink { [weak self] newValue in
            self?.updateUI(modelValue: newValue)
        }
    }

    // MARK: - Abstract methods to override.

    /**
     Common funnel method for setting up the UI managed by the `UIComponent`

     This abstract method is separate from `viewDidLoad` so this class' override of the `UIViewController` method can
     enforce the order in which UI is set up and the subscription to the controller model updates is started.

     There is no need to call `super` when overriding this method. There is no need to override it either.
     */
    open func setUpUI() {
        // This method intentionally left blank.
    }

    /**
     Updates the UI component's managed UI based on the new value for its controller's model.

     This method is the funnel for getting the UI up to date with the controller's model value. If the implementation
     gets too unwieldy you should probably think of decomposing your view controller into subcomponents.

     Don't call `super`, this is a pure abstract method. Even if your view controller is purely static you should
     provide an implementation override to run during UI initialization (see ``UIComponent.viewDidLoad``)
     - Warning: At the time of this call `controller.model` may not be up to date with `newValue` yet, although
     `modelProperty.value` should already contain `newValue` per the API contract of `ReadOnlyProperty`. Either way you
     shouldn't depend on access to either of those for the implementation of this method.
     - Parameter modelValue: The new value for the controller's model.
     */
    open func updateUI(modelValue _: Controller.ModelProperty.Value) {
        // This method intentionally left boom.
        assertionFailure("UIComponent.updateUI(modelValue:) is expected to be overridden.")
    }
}
#endif
