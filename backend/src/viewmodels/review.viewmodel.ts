import { ReviewModel } from '../models/review.model.js';

// Lop xu ly nghiep vu cho: Danh gia
export class ReviewViewModel {
  private model = new ReviewModel();

  listByProduct(productId: string) {
    return this.model.findByProduct(productId);
  }

  create(input: { userId: string; productId: string; orderItemId: string; rating: number; comment?: string }) {
    if (!input.orderItemId) throw new Error('Thieu thong tin don hang da mua');
    if (!Number.isInteger(input.rating) || input.rating < 1 || input.rating > 5) {
      throw new Error('So sao phai tu 1 den 5');
    }
    return this.model.create(input);
  }

  remove(reviewId: string, userId: string) {
    return this.model.removeOwn(reviewId, userId);
  }
}
