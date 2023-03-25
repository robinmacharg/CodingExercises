import UIKit
import SwiftUI

/// Displays a welcome dashboard containing a countdown to the next menu release.
class DashboardViewController: UIViewController {

    // MARK: Properties

    public let countdownContext: CountdownContext

    // MARK: Private Properties

    private lazy var backgroundImageView: UIImageView = {

        let imageView = UIImageView(image: UIImage(named: "gingerbread-shake")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private lazy var logoImageView: UIImageView = {

        let imageView = UIImageView(image: UIImage(named: "logo")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "Gousto logo"

        return imageView
    }()

    private lazy var contentContainer: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "primaryBackground")
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return view
    }()

    private lazy var titleLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("dashboard.content.title", comment: "A title for the dashboard content")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)

        return label
    }()

    private lazy var introductionLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("dashboard.content.introduction", comment: "A brief introduction to Gousto")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var countdownGuide: UILayoutGuide = UILayoutGuide()

    private lazy var countdownLabel: UILabel = {

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.textColor = UIColor(named: "brandRed")
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0

        return label
    }()

    private lazy var marketplaceButton: UIButton = {

        let button = UIButton(
            type: .custom,
            primaryAction: UIAction { _ in
                print("Open Marketplace")
                let body = Empty()

                Task {
                    do {
                        guard let response = try await APIService.shared.makeAsyncRequest(
                            "https://api.gousto.co.uk/products/v2.0/products?image_sizes%5B%5D=750",
                            method: .GET,
                            body: body,
                            returnType: ResponsePayload<[Product]>?.self) else {
                            Log.error("Error")
                            return
                        }
                        let productView = ProductListView(products: response.data)
                        let hostingController = UIHostingController(rootView: productView)
                        self.show(hostingController, sender: self)
                    } catch let error {
                        Log.error("Error: \(error)")
                    }
                }
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("dashboard.button.marketplace_title", comment: "Marketplace button title"), for: .normal)
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = UIColor(named: "primaryControlBackground")
        button.setTitleColor(UIColor(named: "primaryControlText"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.cornerRadius = 3

        return button
    }()

    // MARK: Initialisation

    init(countdownContext: CountdownContext) {

        self.countdownContext = countdownContext

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, deprecated)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundImageView)
        view.addSubview(contentContainer)
        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(introductionLabel)
        contentContainer.addLayoutGuide(countdownGuide)
        contentContainer.addSubview(countdownLabel)
        contentContainer.addSubview(marketplaceButton)
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),

            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: contentContainer.topAnchor),

            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.readableContentGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),

            introductionLabel.leadingAnchor.constraint(equalTo: contentContainer.readableContentGuide.leadingAnchor),
            introductionLabel.trailingAnchor.constraint(equalTo: contentContainer.readableContentGuide.trailingAnchor),
            introductionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),

            countdownGuide.leadingAnchor.constraint(equalTo: contentContainer.readableContentGuide.leadingAnchor),
            countdownGuide.trailingAnchor.constraint(equalTo: contentContainer.readableContentGuide.trailingAnchor),
            countdownGuide.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor),
            countdownGuide.bottomAnchor.constraint(equalTo: marketplaceButton.topAnchor),

            countdownLabel.centerYAnchor.constraint(equalTo: countdownGuide.centerYAnchor),
            countdownLabel.centerXAnchor.constraint(equalTo: countdownGuide.centerXAnchor),
            countdownLabel.leadingAnchor.constraint(greaterThanOrEqualTo: countdownGuide.leadingAnchor),
            countdownLabel.trailingAnchor.constraint(greaterThanOrEqualTo: countdownGuide.trailingAnchor),

            marketplaceButton.leadingAnchor.constraint(equalTo: contentContainer.readableContentGuide.leadingAnchor),
            marketplaceButton.trailingAnchor.constraint(equalTo: contentContainer.readableContentGuide.trailingAnchor),
            marketplaceButton.heightAnchor.constraint(equalToConstant: 44),
            marketplaceButton.bottomAnchor.constraint(equalTo: contentContainer.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startCountdown()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopCountdown()
    }

    // MARK: Private Methods

    private func startCountdown() {

        guard let nextReleaseDate = Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(
                hour: 12,
                weekday: 3),
            matchingPolicy: .nextTime) else {
            fatalError("Unable to determine the next release date")
        }

        self.countdownContext.start(countdownTo: nextReleaseDate) { [unowned self] countdownUpdateText in
            self.countdownLabel.text = countdownUpdateText
        }
    }

    private func stopCountdown() {
        self.countdownContext.stop()
    }
}
