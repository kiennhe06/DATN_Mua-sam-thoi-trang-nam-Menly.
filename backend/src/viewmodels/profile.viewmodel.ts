import { ProfileModel, type UserProfile, type ProfileUpdateDTO } from '../models/profile.model.js';

// Lop xu ly nghiep vu cho: Ho so ca nhan
export class ProfileViewModel {
  private model = new ProfileModel();

  async getProfile(userId: string): Promise<UserProfile> {
    return this.model.getProfile(userId);
  }

  async get(userId: string) {
    return this.model.getById(userId);
  }

  async updateProfile(userId: string, input: ProfileUpdateDTO): Promise<UserProfile> {
    return this.model.updateProfile(userId, input);
  }

  async update(userId: string, fields: { fullName?: string; phone?: string }) {
    return this.model.update(userId, {
      full_name: fields.fullName,
      phone: fields.phone,
    });
  }

  async updateAvatar(userId: string, avatarUrl: string) {
    if (!avatarUrl) throw new Error('Thieu dia chi anh');
    return this.model.update(userId, { avatar_url: avatarUrl });
  }

  async uploadAvatar(userId: string, file: Express.Multer.File): Promise<{ avatarUrl: string; filePath: string }> {
    return this.model.uploadAvatar(userId, file);
  }
}
