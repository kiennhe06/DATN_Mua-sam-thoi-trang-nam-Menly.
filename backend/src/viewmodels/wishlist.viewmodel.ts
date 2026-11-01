import { WishlistModel } from '../models/wishlist.model.js';

// Lop xu ly nghiep vu cho: Yeu thich
export class WishlistViewModel {
  private model = new WishlistModel();

  list(userId: string) {
    return this.model.findByUser(userId);
  }

  add(userId: string, productId: string) {
    return this.model.add(userId, productId);
  }

  remove(userId: string, productId: string) {
    return this.model.remove(userId, productId);
  }

  check(userId: string, productId: string) {
    return this.model.exists(userId, productId);
  }
}
