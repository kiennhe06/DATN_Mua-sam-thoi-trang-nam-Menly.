import { ProductModel } from '../models/product.model.js';

// Lop xu ly nghiep vu cho: San pham
export class ProductViewModel {
  private model = new ProductModel();

  getProducts(opts: { search?: string; categoryId?: string; limit?: number }) {
    return this.model.findAll(opts);
  }

  getProductById(id: string) {
    return this.model.findById(id);
  }
}
