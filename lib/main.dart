import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingApp());
}

// Step 8: the model. A name, a bought status, and (push further) a quantity.
class Item {
  Item(this.name);
  final String name;
  bool bought = false;
  int quantity = 1;
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Step 3 "Your turn": a different colour than green.
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const HomeScreen(title: 'Shopping List'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Step 4 "Your turn": Eggs added.
  final items = [Item('Milk'), Item('Bread'), Item('Rice'), Item('Eggs')];

  final controller = TextEditingController();

  void addItem() {
    final text = controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Type an item first')),
      );
      return;
    }

    // Step 6 "Your turn" 2: refuse duplicates.
    if (items.any((item) => item.name.toLowerCase() == text.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$text is already on the list')),
      );
      return;
    }

    setState(() {
      // New items go above the bought ones, so bought items stay at the bottom.
      final firstBought = items.indexWhere((item) => item.bought);
      if (firstBought == -1) {
        items.add(Item(text));
      } else {
        items.insert(firstBought, Item(text));
      }
    });
    controller.clear();
  }

  // Push further 3: bought items go to the bottom, un-bought go back up.
  void toggleBought(Item item) {
    setState(() {
      item.bought = !item.bought;
      items.remove(item);
      if (item.bought) {
        items.add(item);
      } else {
        final firstBought = items.indexWhere((i) => i.bought);
        if (firstBought == -1) {
          items.add(item);
        } else {
          items.insert(firstBought, item);
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = items.where((item) => !item.bought).length;

    return Scaffold(
      appBar: AppBar(
        // Step 2 "Your turn": a coloured AppBar.
        backgroundColor: Colors.amber,
        // Step 5 + 8: how many items are left.
        title: Text('${widget.title} ($left left)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: () {
              setState(() {
                items.removeWhere((item) => item.bought);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Add an item'),
                    // Step 6 "Your turn" 1: Enter adds the item.
                    onSubmitted: (_) => addItem(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            // Push further 1: empty state.
            child: items.isEmpty
                ? const Center(
              child: Text(
                'Your list is empty',
                // Step 2 "Your turn": bigger text.
                style: TextStyle(fontSize: 24),
              ),
            )
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(
                    item.bought
                        ? Icons.check_circle
                        : Icons.shopping_basket,
                  ),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration: item.bought
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  // Step 4 "Your turn": Item 1, Item 2, ...
                  subtitle: Text('Item ${index + 1}'),
                  onTap: () => toggleBought(item),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Push further 2: quantity with - and +.
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: item.quantity > 1
                            ? () {
                          setState(() {
                            item.quantity--;
                          });
                        }
                            : null,
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            item.quantity++;
                          });
                        },
                      ),
                      // Step 7: the bin.
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          final name = item.name;
                          setState(() {
                            items.removeAt(index);
                          });
                          // Step 7 "Your turn": removed message.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$name removed')),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}