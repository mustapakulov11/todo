import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> todos = [];
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<TodoItem> incompleteTodos = todos.where((todo) => !todo.isDone).toList();
    List<TodoItem> completeTodos = todos.where((todo) => todo.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Список задач'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Обработка нажатия на иконку поиска (если необходимо)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск задач',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Обработка изменения текста в поле поиска
                // Можно добавить фильтрацию задач на основе введенного текста
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: incompleteTodos.length,
              itemBuilder: (context, index) {
                return _buildTodoItem(incompleteTodos[index]);
              },
            ),
          ),
          Divider(), // Линия разделения
          _buildDropdownList(completeTodos),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        tooltip: 'Добавить задачу',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoItem(TodoItem todo) {
    return ListTile(
      title: Text(todo.text),
      leading: Checkbox(
        value: todo.isDone,
        onChanged: (bool? value) {
          setState(() {
            todo.isDone = value!;
          });
        },
      ),
    );
  }

  Widget _buildDropdownList(List<TodoItem> completeTodos) {
    if (completeTodos.isEmpty) {
      return Container(); // Пустой контейнер, если завершенных задач нет
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Завершенные задачи',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        DropdownButton<TodoItem>(
          value: null, // Выбранный элемент, пустой, так как ничего не выбрано изначально
          hint: Text('Выберите задачу'),
          items: completeTodos.map((TodoItem todo) {
            return DropdownMenuItem<TodoItem>(
              value: todo,
              child: Text(todo.text),
            );
          }).toList(),
          onChanged: (TodoItem? selectedTodo) {
            // Обработка выбора задачи из выпадающего списка
            if (selectedTodo != null) {
              // Здесь можно добавить код для обработки выбранной задачи
            }
          },
        ),
      ],
    );
  }

  void _addTodo() {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Введите свои задачи"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_textFieldController.text.isNotEmpty &&
                    _textFieldController.text.trim() != "") {
                  setState(() {
                    todos.add(TodoItem(
                      text: _textFieldController.text,
                      isDone: false,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}

class TodoItem {
  String text;
  bool isDone;

  TodoItem({required this.text, required this.isDone});
}
