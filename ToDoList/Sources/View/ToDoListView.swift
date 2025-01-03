import SwiftUI

struct ToDoListView: View {
    @ObservedObject var viewModel: ToDoListViewModel
    @State private var newTodoTitle = ""
    @State private var isShowingAlert = false
    @State private var isAddingTodo = false
    
    // New state for filter index
    @State private var filterIndex: FilterState = .all
    
    var body: some View {
        NavigationView {
            VStack {
                // Filter selector
                // TODO: - Add a filter selector which will call the viewModel for updating the displayed data
                PickerView(filterIndex: $filterIndex)
                    .onChange(of: filterIndex) { selectedIndex in
                        // update filtered list in viewModel
                        viewModel.applyFilter(at: selectedIndex)
                    }
                // List of tasks
                ToDoListView(viewModel: viewModel)
                // Sticky bottom view for adding todos
                if isAddingTodo {
                    addToDoTexField
                }
                // Button to toggle the bottom add view
                addTaskButton
            }
            .navigationBarTitle("To-Do List")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

// MARK: Picker View

private extension ToDoListView {
    
    struct PickerView: View {
        @Binding var filterIndex: FilterState
        
        var body: some View {
            Picker("Filter", selection: $filterIndex) {
                Text(FilterState.all.rawValue).tag(FilterState.all)
                Text(FilterState.done.rawValue).tag(FilterState.done)
                Text(FilterState.notDone.rawValue).tag(FilterState.notDone)
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
}

// MARK: List View

private extension ToDoListView {
    
    struct ToDoListView: View {
        @ObservedObject var viewModel: ToDoListViewModel
        
        var body: some View {
            List {
                ForEach(viewModel.toDoItems) { item in
                    HStack {
                        Button(action: {
                            viewModel.toggleTodoItemCompletion(item)
                        }) {
                            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(item.isDone ? .green : .primary)
                        }
                        Text(item.title)
                            .font(item.isDone ? .subheadline : .body)
                            .strikethrough(item.isDone)
                            .foregroundColor(item.isDone ? .gray : .primary)
                    }
                }
                .onDelete { indices in
                    indices.forEach { index in
                        let item = viewModel.toDoItems[index]
                        viewModel.removeTodoItem(item)
                    }
                }
            }
        }
    }
}

// MARK: Add toDo

private extension ToDoListView {
    
    var addToDoTexField: some View {
        HStack {
            TextField("Enter Task Title", text: $newTodoTitle)
                .padding(.leading)
            
            Spacer()
            
            Button(action: {
                if newTodoTitle.isEmpty {
                    isShowingAlert = true
                } else {
                    // Ben: Change filter if "Done" state to see new item appear
                    if filterIndex == .done {
                        filterIndex = .all
                    }
                    // add to viewModel
                    viewModel.add(
                        item: .init(
                            title: newTodoTitle
                        )
                    )
                    newTodoTitle = "" // Reset newTodoTitle to empty.
                    isAddingTodo = false // Close the bottom view after adding
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
    
    var addTaskButton: some View {
        Button(action: {
            isAddingTodo.toggle()
        }) {
            Text(isAddingTodo ? "Close" : "Add Task")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 5)
        }
        .padding()
    }
}

// MARK: Preview

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(
            viewModel: ToDoListViewModel(
                repository: ToDoListRepository()
            )
        )
    }
}

