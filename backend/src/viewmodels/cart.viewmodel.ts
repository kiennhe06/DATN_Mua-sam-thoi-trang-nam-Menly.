import { CartModel } from '../models/cart.model.js';

// Lop xu ly nghiep vu cho: Gio hang
export class CartViewModel {
  private model = new CartModel();

  list(userId: string) {
    return this.model.findByUser(userId);
  }

  // Kiem tra so luong hop le roi them/cap nhat
  setItem(userId: string, variantId: string, quantity: number) {
    if (!variantId) throw new Error('Thieu san pham');
    if (!Number.isInteger(quantity) || quantity < 1 || quantity > 20) {
      throw new Error('So luong phai tu 1 den 20');
    }
    return this.model.upsertItem(userId, variantId, quantity);
  }

  removeItem(userId: string, variantId: string) {
    return this.model.removeItem(userId, variantId);
  }

  clear(userId: string) {
    return this.model.clear(userId);
  }
}
