import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    private var filterApplied = false

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.toDoItems = repository.loadToDoItems()
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            if !filterApplied {
                repository.saveToDoItems(toDoItems)
            }
        }
    }

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
    func applyFilter(at index: Int) {
        // TODO: - Implement the logic for filtering
        // update filterApplied value
        filterApplied = index != 0
        
        switch index {
        case 0:
            toDoItems = repository.loadToDoItems()
        case 1:
            toDoItems = repository.loadToDoItems().filter({ $0.isDone == true })
        case 2:
            toDoItems = repository.loadToDoItems().filter({ $0.isDone == false })
        default:
            break
        }
    }
}
