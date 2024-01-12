import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    private var currentFilterValue: Int = 0

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
    func applyFilter(at index: Int) {
        // TODO: - Implement the logic for filtering
        currentFilterValue = index
        switch index {
        case 0:
            filteredItems = toDoItems
        case 1:
            filteredItems = toDoItems.filter({ $0.isDone == true })
        case 2:
            filteredItems = toDoItems.filter({ $0.isDone == false })
        default:
            filteredItems = toDoItems
        }
    }

    private func updateFilteredList() {
        applyFilter(at: currentFilterValue)
    }
}




//import SwiftUI
//
//final class ToDoListViewModel: ObservableObject {
//    // MARK: - Private properties
//
//    private let repository: ToDoListRepositoryType
//    private var filterApplied = false
//
//    // MARK: - Init
//
//    init(repository: ToDoListRepositoryType) {
//        self.repository = repository
//        self.toDoItems = repository.loadToDoItems()
//    }
//
//    // MARK: - Outputs
//
//    /// Publisher for the list of to-do items.
//    @Published var toDoItems: [ToDoItem] = [] {
//        didSet {
//            // not save if filter is applied to avoid losing items
//            if !filterApplied {
//                repository.saveToDoItems(toDoItems)
//            }
//        }
//    }
//
//    // MARK: - Inputs
//
//    // Add a new to-do item with priority and category
//    func add(item: ToDoItem) {
//        toDoItems.append(item)
//    }
//
//    /// Toggles the completion status of a to-do item.
//    func toggleTodoItemCompletion(_ item: ToDoItem) {
//        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
//            toDoItems[index].isDone.toggle()
//        }
//    }
//
//    /// Removes a to-do item from the list.
//    func removeTodoItem(_ item: ToDoItem) {
//        toDoItems.removeAll { $0.id == item.id }
//    }
//
//    /// Apply the filter to update the list.
//    func applyFilter(at index: Int) {
//        // TODO: - Implement the logic for filtering
//        // update filterApplied value
//        filterApplied = index != 0
//        
//        switch index {
//        case 0:
//            toDoItems = repository.loadToDoItems()
//        case 1:
//            toDoItems = repository.loadToDoItems().filter({ $0.isDone == true })
//        case 2:
//            toDoItems = repository.loadToDoItems().filter({ $0.isDone == false })
//        default:
//            break
//        }
//    }
//}
