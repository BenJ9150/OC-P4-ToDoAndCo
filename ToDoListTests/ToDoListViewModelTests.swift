import XCTest
import Combine
@testable import ToDoList

final class ToDoListViewModelTests: XCTestCase {
    // MARK: - Properties
    
    private var viewModel: ToDoListViewModel!
    private var repository: MockToDoListRepository!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        repository = MockToDoListRepository()
        viewModel = ToDoListViewModel(repository: repository)
    }
    
    // MARK: - Tear Down
    
    override func tearDown() {
        viewModel = nil
        repository = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testAddTodoItem() {
        // Given
        let item = ToDoItem(title: "Test Task")
        
        // When
        viewModel.add(item: item)
        
        // Then
        XCTAssertEqual(viewModel.toDoItems.count, 1)
        XCTAssertTrue(viewModel.toDoItems[0].title == "Test Task")
    }
    
    func testToggleTodoItemCompletion() {
        // Given
        let item = ToDoItem(title: "Test Task")
        viewModel.add(item: item)
        
        // When
        viewModel.toggleTodoItemCompletion(item)
        
        // Then
        XCTAssertTrue(viewModel.toDoItems[0].isDone)
    }
    
    func testRemoveTodoItem() {
        // Given
        let item = ToDoItem(title: "Test Task")
        viewModel.add(item: item) // Changed by Ben, old: .toDoItems.append(item)
        // Cause of change: toDoItems has now a private set
        // So I use .add() to append item to savedItems, and toDoItems is updated on didSet of savedItems
        // Note: If not possible to change test, make the toDoItems set public, and test will also be valid
        
        // When
        viewModel.removeTodoItem(item)
        
        // Then
        XCTAssertTrue(viewModel.toDoItems.isEmpty)
    }
    
    func testFilteredToDoItems() {
        // Given
        let item1 = ToDoItem(title: "Task 1", isDone: true)
        let item2 = ToDoItem(title: "Task 2", isDone: false)
        viewModel.add(item: item1)
        viewModel.add(item: item2)
        
        // When
        viewModel.applyFilter(at: .all) // Changed by Ben, Int replaced by Enum, old: (at: 0)
        // Then
        XCTAssertEqual(viewModel.toDoItems.count, 2)
        
        // When
        viewModel.applyFilter(at: .done) // Changed by Ben, Int replaced by Enum, old: (at: 1)
        // Then
        XCTAssertEqual(viewModel.toDoItems.count, 1)
        
        // When
        viewModel.applyFilter(at: .notDone) // Changed by Ben, Int replaced by Enum, old: (at: 2)
        // Then
        XCTAssertEqual(viewModel.toDoItems.count, 1)
    }
}
