import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todo/pages/log_in_page.dart';
import 'package:todo/services/database_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _todoController = TextEditingController();
  bool isComplet = false;
  bool _switch = false;
  bool circular = false;

  void clearText() {
    _todoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: const Text(
          "ToDo",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: _sModalBottomSheet,
              icon: const Icon(
                Iconsax.setting,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          StreamBuilder<List<Todo>>(
            stream: DatabaseService().listTodos(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              }
              List<Todo>? todos = snapshot.data;
              return SizedBox(
                height: 500,
                width: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[800],
                  ),
                  itemCount: todos!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(todos[index].title),
                      background: Container(
                        padding: const EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        color: Colors.red,
                        child: const Icon(Icons.delete),
                      ),
                      onDismissed: (direction) async {
                        await DatabaseService().removeTodo(todos[index].uid);
                      },
                      child: todos[index].isComplet
                          ? Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: const Color(0xff3B999B),
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                onTap: () {
                                  DatabaseService()
                                      .completTask(todos[index].uid);
                                },
                                leading: Container(
                                  padding: const EdgeInsets.all(2),
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: todos[index].isComplet
                                      ? const Icon(
                                          Iconsax.tick_circle,
                                          color: Color(0xff3B999B),
                                        )
                                      : Container(),
                                ),
                                title: Text(
                                  todos[index].title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[200],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffEE5873),
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                onTap: () {
                                  DatabaseService()
                                      .completTask(todos[index].uid);
                                },
                                leading: Container(
                                  padding: const EdgeInsets.all(2),
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: todos[index].isComplet
                                      ? const Icon(
                                          Iconsax.tick_circle,
                                          color: Color(0xff3B999B),
                                        )
                                      : Container(),
                                ),
                                title: Text(
                                  todos[index].title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[200],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xffEE5873)),
        child: FloatingActionButton(
          onPressed: _fModalBottomSheet,
          tooltip: 'Increment',
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: SvgPicture.asset(
            "assets/icons/document.svg",
            color: Colors.white,
            height: 30,
            width: 30,
          ),
        ),
      ),
    ));
  }

  void _fModalBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      backgroundColor: const Color(0xffd9d9d9),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 30, left: 10),
                      child: const Text("Add todo",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: _todoController,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          fillColor: const Color(0xff50C4ED).withOpacity(0),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xffEE5873),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0),
                        onPressed: () async {
                          setState(() {
                            circular = true;
                          });
                          try {
                            if (_todoController.text.isNotEmpty) {
                              await DatabaseService()
                                  .createNewTodo(_todoController.text.trim());
                              Navigator.pop(context);
                            }
                            setState(() {
                              circular = false;
                            });
                          } catch (e) {
                            final snackbar =
                                SnackBar(content: Text(e.toString()));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                            setState(() {
                              circular = false;
                            });
                          }
                          _todoController.clear();
                        },
                        child: const Text(
                          "Add todo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                  ]),
            ),
          ]),
        );
      },
    );
  }

  void _sModalBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      backgroundColor: const Color(0xffd9d9d9),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 35, left: 10),
                      child: const Text("Settings",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ListTile(
                      title: const Text("Dark mode",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      trailing: CupertinoSwitch(
                        value: _switch,
                        onChanged: (bool value) {
                          setState(() {
                            _switch = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _switch = !_switch;
                        });
                      },
                    ),
                    Container(
                        height: 55,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _logOutDialog();
                          },
                          child: const Text("Log out",
                              style: TextStyle(
                                  color: Color(0xffEE5873),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                        ))
                  ]),
            ),
          ]),
        );
      },
    );
  }

  void _logOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: const Text("Do you want to really \nlog out to the ToDo?",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("Cancel",
                    style: TextStyle(
                        color: Color(0xffEE5873),
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffFF002E)),
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xffEE5873).withOpacity(0.5)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, elevation: 0.0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LogInPage()),
                    );
                  },
                  child: const Text("Log out",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
