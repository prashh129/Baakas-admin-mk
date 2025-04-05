import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/sizes.dart';
import '../../utils/popups/full_screen_loader.dart';
import '../../utils/popups/loaders.dart';

/// A generic controller class for managing data tables using GetX state management.
/// This class provides common functionalities for handling data tables, including fetching, updating, and deleting items.
abstract class BaakasBaseController<Baakas> extends GetxController {
  RxBool isLoading = true.obs; // Observables for managing loading state
  RxInt sortColumnIndex =
      1.obs; // Observable for tracking the index of the column for sorting
  RxBool sortAscending = true
      .obs; // Observable for tracking the sorting order (ascending or descending)
  RxList<Baakas> allItems =
      <Baakas>[].obs; // Observable list to store all items
  RxList<Baakas> filteredItems =
      <Baakas>[].obs; // Observable list to store filtered items
  RxList<bool> selectedRows =
      <bool>[].obs; // Observable list to store selected rows
  final searchTextController =
      TextEditingController(); // Controller for handling search text input

  @override
  void onInit() {
    fetchData(); // Initialize data fetching when the controller is initialized
    super.onInit();
  }

  /// Abstract method to be implemented by subclasses for fetching items.
  Future<List<Baakas>> fetchItems();

  /// Abstract method to be implemented by subclasses for deleting an item.
  Future<void> deleteItem(Baakas item);

  /// Abstract method to be implemented by subclasses for checking if an item contains the search query.
  bool containsSearchQuery(Baakas item, String query);

  /// Common method for fetching data.
  Future<void> fetchData() async {
    try {
      isLoading.value = true; // Set loading state to true
      List<Baakas> fetchedItems = [];
      if (allItems.isEmpty) {
        fetchedItems =
            await fetchItems(); // Fetch items (to be implemented in subclasses)
      }
      allItems
          .assignAll(fetchedItems); // Assign fetched items to the allItems list
      filteredItems
          .assignAll(allItems); // Initially, set filtered items to all items
      selectedRows.assignAll(List.generate(
          allItems.length, (index) => false)); // Initialize selected rows
    } catch (e) {
      // Handle error (to be implemented in subclasses)
    } finally {
      isLoading.value =
          false; // Set loading state to false, regardless of success or failure
    }
  }

  /// Common method for searching based on a query
  void searchQuery(String query) {
    filteredItems.assignAll(
      allItems.where((item) => containsSearchQuery(item, query)),
    );

    // Notify listeners about the change
    update();
  }

  /// Common method for sorting items by a property
  void sortByProperty(
      int sortColumnIndex, bool ascending, Function(Baakas) property) {
    sortAscending.value = ascending;
    filteredItems.sort((a, b) {
      if (ascending) {
        return property(a).compareTo(property(b));
      } else {
        return property(b).compareTo(property(a));
      }
    });
    this.sortColumnIndex.value = sortColumnIndex;

    update();
  }

  /// Method for adding an item to the lists.
  void addItemToLists(Baakas item) {
    allItems.add(item);
    filteredItems.add(item);
    selectedRows.assignAll(List.generate(
        allItems.length, (index) => false)); // Initialize selected rows
    allItems.refresh(); // Refresh the UI to reflect the changes
  }

  /// Method for updating an item in the lists.
  void updateItemFromLists(Baakas item) {
    final itemIndex = allItems.indexWhere((i) => i == item);
    final filteredItemIndex = filteredItems.indexWhere((i) => i == item);

    if (itemIndex != -1) allItems[itemIndex] = item;
    if (filteredItemIndex != -1) filteredItems[itemIndex] = item;

    allItems.refresh(); // Refresh the UI to reflect the changes
  }

  /// Method for removing an item from the lists.
  void removeItemFromLists(Baakas item) {
    allItems.remove(item);
    filteredItems.remove(item);
    selectedRows.assignAll(List.generate(
        allItems.length, (index) => false)); // Initialize selected rows

    update(); // Trigger UI update
  }

  /// Common method for confirming deletion and performing the deletion.
  Future<void> confirmAndDeleteItem(Baakas item) async {
    try {
      // Show a confirmation dialog
      Get.defaultDialog(
        title: 'Delete Item',
        content: const Text('Are you sure you want to delete this item?'),
        confirm: SizedBox(
          width: 60,
          child: ElevatedButton(
            onPressed: () async => await deleteOnConfirm(item),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: BaakasSizes.buttonHeight / 2),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(BaakasSizes.buttonRadius * 5)),
            ),
            child: const Text('Ok'),
          ),
        ),
        cancel: SizedBox(
          width: 80,
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: BaakasSizes.buttonHeight / 2),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(BaakasSizes.buttonRadius * 5)),
            ),
            child: const Text('Cancel'),
          ),
        ),
      );
    } catch (e) {
      // Handle error (to be implemented in subclasses)
    }
  }

  /// Method to be implemented by subclasses for handling confirmation before deleting an item.
  Future<void> deleteOnConfirm(Baakas item) async {
    try {
      // Remove the Confirmation Dialog
      BaakasFullScreenLoader.stopLoading();

      // Start the loader
      BaakasFullScreenLoader.popUpCircular();

      // Delete Firestore Data
      await deleteItem(item);

      removeItemFromLists(item);

      update();

      BaakasFullScreenLoader.stopLoading();
      BaakasLoaders.successSnackBar(
          title: 'Item Deleted', message: 'Your Item has been Deleted');
    } catch (e) {
      BaakasFullScreenLoader.stopLoading();
      BaakasLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
