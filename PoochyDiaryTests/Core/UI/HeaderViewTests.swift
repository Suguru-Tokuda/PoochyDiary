import Testing
import UIKit

@testable import PoochyDiary

@MainActor
struct HeaderViewTests {
    @Test func petSelectorWorksWithoutTitleOrButtons() throws {
        let header = HeaderView()
        #expect(header.title == nil)
        header.petName = "Leo"
        var tapCount = 0
        header.onPetSelectorTap = { tapCount += 1 }
        layout(header)

        let selector = try #require(descendants(of: header).compactMap { $0 as? PetSelectorView }.first)
        #expect(!selector.isHidden)
        #expect(!header.hasAmbiguousLayout)
        #expect(header.bounds.height >= Spacing.space40)
        #expect(header.bounds.contains(selector.convert(selector.bounds, to: header)))
        selector.onTap?()
        #expect(tapCount == 1)

        header.petName = nil
        #expect(selector.isHidden)
        header.petName = "Taiga"
        #expect(!selector.isHidden)
        #expect(selector.model?.name == "Taiga")
    }

    @Test func trailingButtonsCanBeAddedReplacedAndRemoved() {
        let header = HeaderView()
        header.petName = "Leo"
        let first = CircleButton(image: nil)
        let second = CircleButton(image: nil)
        var tapCount = 0
        second.addAction(UIAction { _ in tapCount += 1 }, for: .touchUpInside)

        header.trailingButtons = [first]
        layout(header)
        #expect(first.isDescendant(of: header))
        #expect(first.convert(first.bounds, to: header).maxX == header.bounds.maxX)

        header.trailingButtons = [second]
        layout(header)
        #expect(first.superview == nil)
        #expect(second.isDescendant(of: header))
        second.sendActions(for: .touchUpInside)
        #expect(tapCount == 1)

        header.trailingButtons = []
        layout(header)
        #expect(second.superview == nil)
        #expect(!header.hasAmbiguousLayout)
        #expect(header.bounds.height == Spacing.space40)
    }

    @Test func longPetNameLeavesRoomForTrailingButtons() throws {
        let header = HeaderView(title: Strings.Diary.title)
        header.petName = "A pet with a very long name that should truncate"
        let buttons = [CircleButton(image: nil), CircleButton(image: nil)]
        header.trailingButtons = buttons
        layout(header)

        let titleLabel = try #require(descendants(of: header).compactMap { $0 as? UILabel }.first {
            $0.text == Strings.Diary.title
        })
        #expect(!titleLabel.isHidden)
        let selector = try #require(descendants(of: header).compactMap { $0 as? PetSelectorView }.first)
        let selectorFrame = selector.convert(selector.bounds, to: header)
        let firstButtonFrame = buttons[0].convert(buttons[0].bounds, to: header)
        #expect(!header.hasAmbiguousLayout)
        #expect(selectorFrame.maxX <= firstButtonFrame.minX)
        for button in buttons {
            #expect(button.bounds.width == Spacing.space48)
            #expect(header.bounds.contains(button.convert(button.bounds, to: header)))
        }
    }

    @Test func diaryHeaderPreservesPetCalendarAndTrackingMenu() throws {
        let diaryHeader = DiaryHeaderView()
        diaryHeader.petName = "Leo"
        var petTapCount = 0
        var calendarTapCount = 0
        diaryHeader.onPetSelectorTap = { petTapCount += 1 }
        diaryHeader.onCalendarButtonTap = { calendarTapCount += 1 }
        layout(diaryHeader)

        let elements = descendants(of: diaryHeader)
        let selector = try #require(elements.compactMap { $0 as? PetSelectorView }.first)
        selector.onTap?()
        #expect(petTapCount == 1)
        let buttons = elements.compactMap { $0 as? CircleButton }
        let calendar = try #require(buttons.first {
            $0.accessibilityLabel == Strings.Diary.selectDateAccessibilityLabel
        })
        calendar.sendActions(for: .touchUpInside)
        #expect(calendarTapCount == 1)
        let addButton = try #require(buttons.first {
            $0.accessibilityLabel == Strings.Diary.addEntryAccessibilityLabel
        })
        #expect(addButton.showsMenuAsPrimaryAction)
        #expect(addButton.menu?.children.map(\.title) == [Strings.Diary.trackPoop, Strings.Diary.trackWeight])
        #expect(diaryHeader.bounds.height == Spacing.space48)
    }

    private func layout(_ view: UIView) {
        let size = view.systemLayoutSizeFitting(
            CGSize(width: 320, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        view.frame = CGRect(origin: .zero, size: size)
        view.layoutIfNeeded()
    }

    private func descendants(of view: UIView) -> [UIView] {
        view.subviews.flatMap { [$0] + descendants(of: $0) }
    }
}
