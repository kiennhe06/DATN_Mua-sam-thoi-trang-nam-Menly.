import { BannerModel } from '../models/banner.model.js';

// Lop xu ly nghiep vu cho: Banner
export class BannerViewModel {
  private model = new BannerModel();

  getActiveBanners() {
    return this.model.findActive();
  }
}
