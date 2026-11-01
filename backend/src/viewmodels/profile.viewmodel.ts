import { ProfileModel } from '../models/profile.model.js';

// Lop xu ly nghiep vu cho: Ho so ca nhan
export class ProfileViewModel {
  private model = new ProfileModel();

  get(userId: string) {
    return this.model.getById(userId);
  }

  update(userId: string, fields: { fullName?: string; phone?: string }) {
    return this.model.update(userId, {
      full_name: fields.fullName,
      phone: fields.phone,
    });
  }

  updateAvatar(userId: string, avatarUrl: string) {
    if (!avatarUrl) throw new Error('Thieu dia chi anh');
    return this.model.update(userId, { avatar_url: avatarUrl });
  }
}
