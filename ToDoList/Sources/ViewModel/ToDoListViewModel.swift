import SwiftUI

enum FilterState: String, CaseIterable, Identifiable {
    case all = "All"
    case done = "Done"
    case notDone = "Not Done"
    var id: Self { self }
}


final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    private var currentFilterValue: FilterState = .all

    private var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
            updateFilteredList()
        }
    }

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.toDoItems = repository.loadToDoItems()
        self.updateFilteredList()
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items (filtered or not)
    @Published private(set) var filteredItems: [ToDoItem] = []

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        toDoItems.append(item)
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].isDone.toggle()
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        toDoItems.removeAll { $0.id == item.id }
    }

    /// Apply the filter to update the list.
    func applyFilter(at filterState: FilterState) {
        // TODO: - Implement the logic for filtering
        currentFilterValue = filterState
        switch filterState {
        case .all:
            filteredItems = toDoItems
        case .done:
            filteredItems = toDoItems.filter({ $0.isDone })
        case .notDone:
            filteredItems = toDoItems.filter({ !$0.isDone })
        }
    }

    private func updateFilteredList() {
        applyFilter(at: currentFilterValue)
    }
}
