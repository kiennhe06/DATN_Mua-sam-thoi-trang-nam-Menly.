import { CartModel, type CartSummary } from '../models/cart.model.js';

// Lop xu ly nghiep vu cho: Gio hang
export class CartViewModel {
  private model = new CartModel();

  async getCart(userId: string): Promise<CartSummary> {
    return this.model.getCart(userId);
  }

  async addItem(userId: string, variantId: string, quantity = 1): Promise<CartSummary> {
    return this.model.addItem(userId, variantId, quantity);
  }

  async updateQuantity(userId: string, variantId: string, quantity: number): Promise<CartSummary> {
    return this.model.updateQuantity(userId, variantId, quantity);
  }

  async removeItem(userId: string, variantId: string): Promise<CartSummary> {
    return this.model.removeItem(userId, variantId);
  }

  async clearCart(userId: string): Promise<{ success: boolean; message: string }> {
    return this.model.clearCart(userId);
  }
}
