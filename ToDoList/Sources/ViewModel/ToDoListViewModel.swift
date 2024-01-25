import SwiftUI

// Ben: Enumeration for filter state
enum FilterState: String {
    case all = "All"
    case done = "Done"
    case notDone = "Not Done"
}


final class ToDoListViewModel: ObservableObject {

    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    private var currentFilterValue: FilterState = .all

    // Ben: savedItems contain all items, never filtered
    private var savedItems: [ToDoItem] = [] {
        didSet {
            // when is set, save items and update the filtered list
            repository.saveToDoItems(savedItems)
            // update with current filter value
            updateFilteredList()
        }
    }

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.savedItems = repository.loadToDoItems()
        self.updateFilteredList()
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items (filtered or not)
    @Published private(set) var toDoItems: [ToDoItem] = []

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        savedItems.append(item)
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = savedItems.firstIndex(where: { $0.id == item.id }) {
            savedItems[index].isDone.toggle()
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        savedItems.removeAll { $0.id == item.id }
    }

    /// Apply the filter to update the list.
    func applyFilter(at filterState: FilterState) {
        // TODO: - Implement the logic for filtering

        // save current filter state to update toDoItems when savedItems has changed
        currentFilterValue = filterState

        // update toDoItems list based on filter state
        switch filterState {
        case .all:
            toDoItems = savedItems
        case .done:
            toDoItems = savedItems.filter({ $0.isDone })
        case .notDone:
            toDoItems = savedItems.filter({ !$0.isDone })
        }
    }
}

// MARK: Private method

private extension ToDoListViewModel {

    /// Ben: update toDoItems list based on current filter state
    func updateFilteredList() {
        // use the current filter value to update filtered list if toDoItems has changed
        applyFilter(at: currentFilterValue)
    }
}
