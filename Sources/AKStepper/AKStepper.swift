import AKButton
import UIKit

public final class CustomStepper: UIControl {

  public struct Configuration {
    public var buttonConfiguration: AKButton.Configuration
    public var buttonSpacing: CGFloat
    public var valueFont: UIFont
    public var valueColor: UIColor
    public var valueFormatter: ((Int) -> NSAttributedString?)?

    public init(
      buttonConfiguration: AKButton.Configuration = .init(),
      buttonSpacing: CGFloat = 3,
      valueFont: UIFont = .preferredFont(forTextStyle: .body),
      valueColor: UIColor = .black,
      valueFormatter: ((Int) -> NSAttributedString?)? = nil
    ) {
      self.buttonConfiguration = buttonConfiguration
      self.buttonSpacing = buttonSpacing
      self.valueFont = valueFont
      self.valueColor = valueColor
      self.valueFormatter = valueFormatter
    }
  }

  // MARK: Subviews

  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .fill
    stackView.axis = .horizontal
    stackView.spacing = configuration.buttonSpacing
    return stackView
  }()

  public private(set) lazy var minusButton: AKButton = {
    let button = AKButton(configuration: configuration.buttonConfiguration)
    button.action = { [weak self] in self?.didTapMinus() }
    button.title = { _ in "-" }
    return button
  }()

  public private(set) lazy var plusButton: AKButton = {
    let button = AKButton(configuration: configuration.buttonConfiguration)
    button.action = { [weak self] in self?.didTapPlus() }
    button.title = { _ in "+" }
    return button
  }()

  public private(set) lazy var valueLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .center
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentCompressionResistancePriority(.required, for: .vertical)
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    return label
  }()

  // MARK: Properties

  public var configuration: Configuration {
    didSet {
      updateConfiguration()
    }
  }

  public override var intrinsicContentSize: CGSize {
    return contentStackView.systemLayoutSizeFitting(.zero)
  }

  private lazy var valueWidthConstraint = valueLabel.widthAnchor.constraint(lessThanOrEqualToConstant: minValueLabelWidth)

  private var minValueLabelWidth: CGFloat {
    if let valueFormatter = configuration.valueFormatter {
      return valueFormatter(99)?.size().width ?? 0
    }
    else {
      return Self.formatter.string(from: 99)?.size().width ?? 0
    }
  }

  private var _value: Int = 0 {
    didSet {
      updateValueState()
    }
  }

  public var value: Int {
    get {
      return _value
    }
    set {
      if newValue < minValue {
        _value = minValue
      }
      else if newValue > maxValue {
        _value = maxValue
      }
      else {
        _value = newValue
      }
    }
  }

  public var minValue: Int = 0 {
    didSet {
      if value < minValue {
        value = minValue
      }
    }
  }

  public var maxValue: Int = 9 {
    didSet {
      if value > maxValue {
        value = maxValue
      }
    }
  }

  private static var formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()

  // MARK: Initialization

  public init(configuration: Configuration = .init()) {
    self.configuration = configuration
    super.init(frame: .zero)
    commonInit()
  }

  public required init?(coder aDecoder: NSCoder) {
    self.configuration = .init()
    super.init(coder: aDecoder)
    commonInit()
  }

  // MARK: Private

  private func commonInit() {
    addSubview(contentStackView)
    contentStackView.addArrangedSubview(minusButton)
    contentStackView.addArrangedSubview(valueLabel)
    contentStackView.addArrangedSubview(plusButton)

    NSLayoutConstraint.activate([
      contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      contentStackView.topAnchor.constraint(equalTo: self.topAnchor),
      contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
    ])

    NSLayoutConstraint.activate([
      plusButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
      plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor),
      minusButton.heightAnchor.constraint(equalTo: plusButton.heightAnchor),
      minusButton.widthAnchor.constraint(equalTo: plusButton.widthAnchor)
    ])

    NSLayoutConstraint.activate([
      valueWidthConstraint
    ])

    updateConfiguration()
  }

  private func didTapMinus() {
    let newValue = value - 1
    guard newValue >= minValue else {
      return
    }

    value = newValue
    sendActions(for: .valueChanged)
  }

  private func didTapPlus() {
    let newValue = value + 1
    guard newValue <= maxValue else {
      return
    }

    value = newValue
    sendActions(for: .valueChanged)
  }

  private func updateConfiguration() {
    contentStackView.spacing = configuration.buttonSpacing
    plusButton.configuration = configuration.buttonConfiguration
    minusButton.configuration = configuration.buttonConfiguration

    if configuration.valueFormatter == nil {
      valueLabel.font = configuration.valueFont
      valueLabel.textColor = configuration.valueColor
    }

    updateValueState()
  }

  private func updateValueState() {
    if let valueFormatter = configuration.valueFormatter {
      valueLabel.attributedText = valueFormatter(_value)
    }
    else {
      valueLabel.text = Self.formatter.string(from: _value as NSNumber)
    }

    valueWidthConstraint.constant = minValueLabelWidth

    minusButton.isEnabled = _value > minValue
    plusButton.isEnabled = _value < maxValue
  }

}
