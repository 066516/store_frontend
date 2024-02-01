import 'package:flutter/material.dart';
import 'package:store_frontend/constants/colors.dart';
import 'package:store_frontend/models/todo.dart';
import 'package:store_frontend/widgets/todo_item.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List todosList = ToDo.todoList();
  final _itemContoler = TextEditingController();
  final _searchItem = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(children: [
              SearchBox(),
              Expanded(
                  child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50, bottom: 20),
                    child: Text("All todos",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ),
                  for (ToDo todoo in todosList)
                    TodoItem(
                      todo: todoo,
                      todoChanged: _handle,
                      todoDeleted: _deleteItem,
                    ),
                ],
              ))
            ]),
          ),
          _newToDos()
        ],
      ),
    );
  }

  Align _newToDos() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: 20,
                bottom: 20,
                left: 20,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              // height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.0, // <-- Add a comma here
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _itemContoler,
                decoration: InputDecoration(
                  hintText: 'add a new todo item',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20, right: 20),
            child: ElevatedButton(
              child: Text(
                '+',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              onPressed: () {
                _addItem(_itemContoler.text);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: tdBlue,
                  minimumSize: Size(60, 60),
                  elevation: 10),
            ),
          )
        ],
      ),
    );
  }

  void _addItem(String todo) {
    setState(() {
      todosList
          .add(ToDo(id: DateTime.now().millisecond.toString(), todoText: todo));
    });
    _itemContoler.clear();
  }

  void _handle(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _handleFilter(String todo) {
    setState(() {
      if (todo.isEmpty) {
        // If the search text is empty, display all todos
        todosList = ToDo.todoList();
      } else {
        // If there's a search text, filter the todos based on it (case-insensitive)
        String lowerCaseTodo = todo.toLowerCase();
        todosList = ToDo.todoList()
            .where((element) =>
                element.todoText?.toLowerCase()?.contains(lowerCaseTodo) ??
                false)
            .toList();
      }
    });
  }

  void _deleteItem(String id) {
    setState(() {
      todosList.removeWhere((element) => element.id == id);
    });
  }

  Widget SearchBox() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: TextField(
          controller: _searchItem,
          onChanged: (_searchItem) {
            _handleFilter(_searchItem);
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(Icons.search, color: tdBlack, size: 30),
              prefixIconConstraints:
                  BoxConstraints(maxHeight: 20, minWidth: 25),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(color: tdGrey)),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/me.png'),
          ),
        )
      ]),
    );
  }
}
