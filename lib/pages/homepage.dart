import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_manager/main.dart';
import 'package:todo_list_manager/pages/add_todo_page.dart';
import 'package:todo_list_manager/providers/theme_provider.dart';
import 'package:todo_list_manager/widgets/completed_list_widget.dart';
import 'package:todo_list_manager/widgets/todo_list_widget.dart';
import 'package:todo_list_manager/widgets/theme_switch_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final tabs = [const TodoListWidget(), const CompletedListWidget()];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyApp.title,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          const ThemeSwitchButton(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.fact_check_outlined,
              color: themeProvider.isDarkMode
                  ? const Color.fromARGB(255, 69, 121, 71)
                  : const Color.fromARGB(255, 255, 255, 255),
            ),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.done,
              size: 28,
              color: themeProvider.isDarkMode
                  ? const Color.fromARGB(255, 69, 121, 71)
                  : const Color.fromARGB(255, 255, 255, 255),
            ),
            label: "Completed",
          ),
        ],
      ),
      body: tabs[selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddTodoPage(),
          ),
        ),
        backgroundColor: themeProvider.isDarkMode
            ? const Color.fromARGB(255, 69, 121, 71)
            : const Color.fromARGB(255, 69, 121, 71),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
