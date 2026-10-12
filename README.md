# Shopping List

My first Flutter app: add items, mark them as bought, and delete them.

## Screenshots

### 1. My list

![myList.png](../../OneDrive/Desktop/INNOVATION/MOBILE/myList.png)

The app opens with a few items already on the list. Each row shows a basket icon, the item name, its position (Item 1, Item 2, ...), a quantity with **+** and **−** buttons, and a bin button. The title at the top shows how many items are still left to buy.

### 2. An item bought

![Type.png](../../OneDrive/Desktop/INNOVATION/MOBILE/Type.png)

When I tap an item, it is marked as bought: its name is crossed out and its icon changes to a tick. The title count goes down by one, and the bought item moves to the bottom of the list. Tapping it again undoes this.

### 3. An empty item refused

![2marked.png](../../OneDrive/Desktop/INNOVATION/MOBILE/2marked.png)

If I tap **Add** with nothing typed in the field, nothing is added to the list. Instead, a message at the bottom of the screen says "Type an item first".

## What the app can do

- Type an item and tap **Add** (or press Enter) to put it on the list
- Refuse empty items and items that are already on the list
- Tap an item to mark it as bought, and tap again to undo
- Change the quantity of an item with **+** and **−**
- Delete one item with the bin button
- Remove all bought items at once with the button in the top bar
- Show "Your list is empty" when there is nothing on the list

## How it works

The app is in one file, `lib/main.dart`. The list is stored in a `List` of `Item` objects, and each `Item` has a name, a bought status and a quantity. When the data changes, the code calls `setState`, which tells Flutter to redraw the screen with the new data.