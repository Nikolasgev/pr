import '../../../../core/firebase/firebase_service.dart';
import '../../domain/entities/product.dart';
import '../models/product_model.dart';

class CatalogRepositoryImpl {
  final FirebaseService firebaseService = FirebaseService();

  Future<List<Product>> getProducts() async {
    final data = await firebaseService.getProducts();
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }
}
