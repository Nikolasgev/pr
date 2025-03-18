import '../entities/product.dart';
import '../../data/repositories/catalog_repository_impl.dart';

class GetProducts {
  final CatalogRepositoryImpl repository;
  GetProducts(this.repository);

  Future<List<Product>> call() async {
    return await repository.getProducts();
  }
}
