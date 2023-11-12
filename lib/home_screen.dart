import 'package:flutter/material.dart';
import 'package:hive_database/boxes/boxes.dart';
import 'package:hive_database/models/note_model.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive DataBase'),
      ),
      body: ValueListenableBuilder<Box<NoteModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NoteModel>();
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(data[index].name.toString()),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  _editDialoge(
                                      data[index],
                                      data[index].name.toString(),
                                      data[index].price.toString());
                                },
                                child: Icon(Icons.edit)),
                            SizedBox(width: 15),
                            InkWell(
                                onTap: () {
                                  deleted(data[index]);
                                },
                                child: Icon(Icons.delete)),
                          ],
                        ),
                        Text(data[index].price.toString())
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialoge();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  //Deleted Function.....................
  void deleted(NoteModel noteModel) async {
    await noteModel.delete();
  }

//Add Function.....................
  Future<void> _showMyDialoge() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Products'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: 'product name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: const InputDecoration(
                        hintText: 'enter price', border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    final data = NoteModel(
                        name: nameController.text, price: priceController.text);
                    final box = Boxes.getData();
                    box.add(data);
                    //data.save();
                    nameController.clear();
                    priceController.clear();

                    Navigator.pop(context);
                  },
                  child: const Text('Add')),
            ],
          );
        });
  }

  //Edit Function.....................
  Future<void> _editDialoge(
      NoteModel noteModel, String name, String price) async {
    nameController.text = name;
    priceController.text = price;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Products'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: 'product name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: const InputDecoration(
                        hintText: 'enter price', border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () async {
                    noteModel.name = nameController.text.toString();
                    noteModel.price = priceController.text.toString();

                    noteModel.save();
                    nameController.clear();
                    priceController.clear();

                    Navigator.pop(context);
                  },
                  child: const Text('Edit')),
            ],
          );
        });
  }
}
