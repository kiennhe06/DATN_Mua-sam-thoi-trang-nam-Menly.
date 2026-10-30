import { CategoryModel } from '../models/category.model.js';

// Lop xu ly nghiep vu cho: Danh muc
export class CategoryViewModel {
  private model = new CategoryModel();

  getCategories() {
    return this.model.findAll();
  }
}
