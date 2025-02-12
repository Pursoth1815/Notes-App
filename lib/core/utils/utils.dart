import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  Future<String?> pickAndSaveImage() async {
    // Pick an image
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery); // You can use ImageSource.camera for camera images

    if (pickedFile != null) {
      // Get the temporary directory of the app
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

      // Save the picked image to the file system
      final File imageFile = File(pickedFile.path);
      await imageFile.copy(imagePath); // Copy the picked file to the app's internal storage

      return imagePath; // Return the path of the saved image
    }

    return null; // Return null if no image was picked
  }
}
