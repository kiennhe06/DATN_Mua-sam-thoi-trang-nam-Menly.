import { CartModel, type CartSummary } from '../models/cart.model.js';

// Lop xu ly nghiep vu cho: Gio hang
export class CartViewModel {
  private model = new CartModel();

  async getCart(userId: string): Promise<CartSummary> {
    return this.model.getCart(userId);
  }

  async list(userId: string) {
    return this.model.findByUser(userId);
  }

  async addItem(userId: string, variantId: string, quantity = 1): Promise<CartSummary> {
    return this.model.addItem(userId, variantId, quantity);
  }

  // Kiem tra so luong hop le roi them/cap nhat
  async setItem(userId: string, variantId: string, quantity: number) {
    if (!variantId) throw new Error('Thieu san pham');
    if (!Number.isInteger(quantity) || quantity < 1 || quantity > 20) {
      throw new Error('So luong phai tu 1 den 20');
    }
    return this.model.upsertItem(userId, variantId, quantity);
  }

  async updateQuantity(userId: string, variantId: string, quantity: number): Promise<CartSummary> {
    return this.model.updateQuantity(userId, variantId, quantity);
  }

  async removeItem(userId: string, variantId: string) {
    return this.model.removeItem(userId, variantId);
  }

  async clearCart(userId: string): Promise<{ success: boolean; message: string }> {
    return this.model.clearCart(userId);
  }

  async clear(userId: string) {
    return this.model.clear(userId);
  }
}
