import Testing
import UIKit

@testable import PoochyDiary

@MainActor
struct TrendsChartViewTests {
    @Test func chartHasContainerBoundsAndReceivesTouches() async throws {
        let scene = try #require(
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        )
        let window = UIWindow(windowScene: scene)
        window.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        let controller = TrendsViewController(viewModel: TrendsViewModel(pet: .mock()))
        var petTapCount = 0
        controller.onPetSelectorTap = { petTapCount += 1 }
        window.rootViewController = controller
        window.isHidden = false
        defer { window.isHidden = true }
        controller.view.layoutIfNeeded()

        let header = try #require(controller.view.subviews.compactMap { $0 as? HeaderView }.first)
        let timeFrames = try #require(controller.view.subviews.compactMap { $0 as? TrendTimeFramesView }.first)
        #expect(header.title == Strings.Tabs.trends)
        #expect(header.petName == "Leo")
        #expect(header.trailingButtons.isEmpty)
        #expect(header.bounds.height > 0)
        #expect(!header.hasAmbiguousLayout)
        #expect(header.frame.maxY < timeFrames.frame.minY)
        header.onPetSelectorTap?()
        #expect(petTapCount == 1)
        controller.viewModel.updatePet(Pet.mockPets()[1])
        await waitForMainQueue()
        #expect(header.petName == "Taiga")

        let scrollView = try #require(controller.view.subviews.compactMap { $0 as? UIScrollView }.first)
        let stack = try #require(scrollView.subviews.compactMap { $0 as? UIStackView }.first)
        let container = try #require(stack.arrangedSubviews.compactMap { $0 as? TrendsChartView }.first)
        let chart = try #require(container.subviews.compactMap { $0 as? ChartUIView }.first)
        #expect(!container.hasAmbiguousLayout)
        #expect(container.bounds.height > 0)
        let pixelTolerance = 1 / controller.traitCollection.displayScale
        #expect(container.bounds.insetBy(dx: -pixelTolerance, dy: -pixelTolerance).contains(chart.frame))
        let chartHeader = try #require(container.subviews.compactMap { $0 as? UIStackView }.first)
        let chartLabels = chartHeader.arrangedSubviews.compactMap { ($0 as? UILabel)?.text }
        #expect(chartLabels.contains(Strings.Trends.poopTrends))
        let totalPoops = try #require(controller.viewModel.model).summary.totalPoops
        #expect(chartLabels.contains(Strings.Trends.loggedPoopCount(count: totalPoops)))
        #expect(chart.frame.minY > chartHeader.frame.maxY)

        scrollView.scrollRectToVisible(container.convert(container.bounds, to: scrollView), animated: false)
        controller.view.layoutIfNeeded()

        let location = chart.convert(
            CGPoint(x: chart.bounds.midX, y: chart.bounds.midY),
            to: controller.view
        )
        let hitView = try #require(controller.view.hitTest(location, with: nil))
        #expect(hitView === chart.host.view || hitView.isDescendant(of: chart.host.view))
        let summary = try #require(stack.arrangedSubviews.compactMap { $0 as? TrendsSummaryView }.first)
        #expect(summary.frame.maxY < container.frame.minY)
        #expect(summary.bounds.height > 0)
        #expect(!summary.hasAmbiguousLayout)
        let weightContainer = try #require(stack.arrangedSubviews.compactMap { $0 as? TrendsWeightChartView }.first)
        let weightChart = try #require(weightContainer.subviews.compactMap { $0 as? WeightChartUIView }.first)
        #expect(weightContainer.frame.minY > container.frame.maxY)
        #expect(weightContainer.bounds.height > 0)
        #expect(!weightContainer.hasAmbiguousLayout)
        #expect(weightContainer.bounds.contains(weightChart.frame))
        #expect(weightChart.host.parent === controller)
        #expect(scrollView.contentSize.height >= weightContainer.frame.maxY)
        scrollView.scrollRectToVisible(weightContainer.convert(weightContainer.bounds, to: scrollView), animated: false)
        controller.view.layoutIfNeeded()
        let weightLocation = weightChart.convert(
            CGPoint(x: weightChart.bounds.midX, y: weightChart.bounds.midY), to: controller.view
        )
        let weightHitView = try #require(controller.view.hitTest(weightLocation, with: nil))
        #expect(weightHitView === weightChart.host.view || weightHitView.isDescendant(of: weightChart.host.view))
    }

    @Test func trendsHeaderFollowsSharedPetSelection() async throws {
        let dependencies = AppDependency()
        let petStore = PetStore()
        dependencies.petStore = petStore
        petStore.select(pet: .mock())
        let navigationController = UINavigationController()
        let coordinator = TrendsCoordinator(navigationController, dependencies: dependencies)
        coordinator.start()
        let controller = try #require(navigationController.viewControllers.first as? TrendsViewController)
        controller.loadViewIfNeeded()
        let header = try #require(controller.view.subviews.compactMap { $0 as? HeaderView }.first)
        #expect(header.petName == "Leo")
        #expect(controller.viewModel.pet?.name == "Leo")

        petStore.select(pet: Pet.mockPets()[1])
        await waitForMainQueue()
        #expect(controller.viewModel.pet?.name == "Taiga")
        await waitForMainQueue()
        #expect(header.petName == "Taiga")
        #expect(controller.onPetSelectorTap != nil)
        withExtendedLifetime(coordinator) {}
    }

    @Test func petSubscriptionStopsOnFinishAndCanRestart() async throws {
        let dependencies = AppDependency()
        let petStore = PetStore()
        dependencies.petStore = petStore
        let pets = Pet.mockPets()
        petStore.select(pet: pets[0])
        let navigationController = UINavigationController()
        let coordinator = TrendsCoordinator(navigationController, dependencies: dependencies)

        // A selection made between initialization and start is still picked up.
        petStore.select(pet: pets[1])
        coordinator.start()
        let controller = try #require(navigationController.viewControllers.first as? TrendsViewController)
        #expect(controller.viewModel.pet == pets[1])
        await waitForMainQueue()
        await waitForMainQueue()

        coordinator.finish()
        petStore.select(pet: pets[2])
        await waitForMainQueue()
        await waitForMainQueue()
        #expect(controller.viewModel.pet == pets[1])

        coordinator.start()
        #expect(navigationController.viewControllers.first === controller)
        #expect(controller.viewModel.pet == pets[2])
        petStore.select(pet: pets[0])
        await waitForMainQueue()
        await waitForMainQueue()
        #expect(controller.viewModel.pet == pets[0])
        withExtendedLifetime(coordinator) {}
    }

    private func waitForMainQueue() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async { continuation.resume() }
        }
    }
}
